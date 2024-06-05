from parse import parser
from lark import Token, Tree

env = {}

def replace_id(tree, old, new):
    if isinstance(tree, Token):
        if tree.type == "NAME" and tree.value == old:
            return new
        return tree
    new_children = []
    for c in tree.children:
        new_children.append(replace_id(c, old, new))
    return Tree(tree.data, new_children)

def inline_name(token, **kwargs):
    name = token.value
    if name in env:
        return inline_tree(env[name][1], **kwargs)
    return token

def inline_array(tree, **kwargs):
    values = tree.children
    new = []
    for val in values:
        new.append(inline_tree(val, **kwargs))
    return Tree("array", new)

def inline_object_field(tree, **kwargs):
    *name, expr = tree.children
    expr = inline_tree(expr, **kwargs)
    return Tree("object_field", [*name, expr])

def inline_object(tree, **kwargs):
    fields = tree.children
    new = []
    for f in fields:
        new.append(inline_tree(f, **kwargs))
    return Tree("object", new)

def inline_table_field(tree, **kwargs):
    key, expr = tree.children
    key = inline_tree(key, **kwargs)
    expr = inline_tree(expr, **kwargs)
    return Tree("table_field", [key, expr])

def inline_table(tree, **kwargs):
    fields = tree.children
    new = []
    for f in fields:
        new.append(inline_tree(f, **kwargs))
    return Tree("table", new)

def inline_unary_expression(tree, **kwargs):
    op, expr = tree.children
    expr = inline_tree(expr, **kwargs)
    return Tree("unary_expression", [op, expr])

def inline_binary_expression(tree, **kwargs):
    left, op, right = tree.children
    left = inline_tree(left, **kwargs)
    right = inline_tree(right, **kwargs)
    return Tree(tree.data, [left, op, right])

def inline_lambda_expression(tree, **kwargs):
    params, expr = tree.children
    expr = inline_tree(expr, **kwargs)
    return Tree("lambda_expression", [params, expr])

def inline_property_access(tree, **kwargs):
    obj, prop = tree.children
    obj = inline_tree(obj, **kwargs)
    return Tree("property_access", [obj, prop])

def inline_method_access(tree, **kwargs):
    obj, method, args = tree.children
    method = inline_tree(method, **kwargs)
    args = inline_tree(args, **kwargs)
    return Tree("method_access", [obj, method, args])

def inline_if_expression(tree, **kwargs):
    cond, then, else_ = tree.children
    cond = inline_tree(cond, **kwargs)
    then = inline_tree(then, **kwargs)
    else_ = inline_tree(else_, **kwargs)
    return Tree("if_expression", [cond, then, else_])

def inline_variable_declaration(tree, **kwargs):
    pat, expr = tree.children
    expr = inline_tree(expr, **kwargs)
    return Tree("variable_declaration", [pat, expr])

def inline_inline_variable_declaration(tree, **kwargs):
    name, expr = tree.children
    env[name] = ([], expr)
    return Tree("empty", [])

def inline_struct_declaration(tree, **kwargs):
    *name, body = tree.children
    body = inline_tree(body, **kwargs)
    return Tree("struct_declaration", [*name, body])

def inline_function_declaration(tree, **kwargs):
    name, params, body = tree.children
    body = inline_tree(body, **kwargs)
    return Tree("function_declaration", [name, params, body])

def inline_inline_function_declaration(tree, **kwargs):
    name, params, expr = tree.children
    env[name] = (params.children, expr)
    return Tree("empty", [])

def inline_argument_list(tree, **kwargs):
    args = tree.children
    new = []
    for a in args:
        new.append(inline_tree(a, **kwargs))
    return Tree("argument_list", new)

def inline_function_call(tree, **kwargs):
    func, args = tree.children
    if isinstance(func, Token) and func.type == "NAME":
        if func.value in env:
            params, expr = env[func.value]
            new_expr = expr
            if len(params) == len(args.children):
                for i, p in enumerate(params):
                    new_expr = replace_id(new_expr, p, args.children[i])
                return inline_tree(new_expr, **kwargs)
            assert False, f"Expected {len(params)} arguments, got {len(args.children)}"
    func = inline_tree(func, **kwargs)
    args = inline_tree(args, **kwargs)
    return Tree("function_call", [func, args])

def inline_return_statement(tree, **kwargs):
    expr, = tree.children
    return Tree("return_statement", [inline_tree(expr, **kwargs)])

def inline_block(tree, **kwargs):
    *stmts, ret = tree.children
    new_stmts = []
    for s in stmts:
        new_stmts.append(inline_tree(s, **kwargs))
    ret = inline_tree(ret, **kwargs)
    return Tree("block", [*new_stmts, ret])

def inline_include_statement(tree, **kwargs):
    path = tree.children[0][1:-1]
    # TODO: change .lua to .luar
    with open(path + ".lua", "r") as f:
        code = f.read()
    tree = parser.parse(code)
    return tree

def inline_program(tree, **kwargs):
    stmts = tree.children
    new_stmts = []
    for s in stmts:
        new_stmts.append(inline_tree(s, **kwargs))
    return Tree("program", new_stmts)

def inline_tree(tree, **kwargs):
    if isinstance(tree, Token):
        return tree
    if tree.data == "array":
        return inline_array(tree, **kwargs)
    if tree.data == "object_field":
        return inline_object_field(tree, **kwargs)
    if tree.data == "object":
        return inline_object(tree, **kwargs)
    if tree.data == "table_field":
        return inline_table_field(tree, **kwargs)
    if tree.data == "table":
        return inline_table(tree, **kwargs)
    if tree.data == "unary_expression":
        return inline_unary_expression(tree, **kwargs)
    if tree.data in ["mul_expression", "add_expression", "rel_expression", "eq_expression", "log_expression"]:
        return inline_binary_expression(tree, **kwargs)
    if tree.data == "binary_expression":
        return inline_binary_expression(tree, **kwargs)
    if tree.data == "lambda_expression":
        return inline_lambda_expression(tree, **kwargs)
    if tree.data == "property_access":
        return inline_property_access(tree, **kwargs)
    if tree.data == "method_access":
        return inline_method_access(tree, **kwargs)
    if tree.data == "variable_declaration":
        return inline_variable_declaration(tree, **kwargs)
    if tree.data == "inline_variable_declaration":
        return inline_inline_variable_declaration(tree, **kwargs)
    if tree.data == "struct_declaration":
        return inline_struct_declaration(tree, **kwargs)
    if tree.data == "function_declaration":
        return inline_function_declaration(tree, **kwargs)
    if tree.data == "inline_function_declaration":
        return inline_inline_function_declaration(tree, **kwargs)
    if tree.data == "argument_list":
        return inline_argument_list(tree, **kwargs)
    if tree.data == "function_call":
        return inline_function_call(tree, **kwargs)
    if tree.data == "return_statement":
        return inline_return_statement(tree, **kwargs)
    if tree.data == "block":
        return inline_block(tree, **kwargs)
    if tree.data == "include_statement":
        return inline_include_statement(tree, **kwargs)
    if tree.data == "program":
        return inline_program(tree, **kwargs)
    return tree

