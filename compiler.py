from lark import Token, Tree
from parse import parser
from inline import inline_tree
import re

def compile_number(code, value, **kwargs):
    code += value
    return code

def compile_string(code, value, **kwargs):
    code += value
    return code

def compile_template_literal(code, value, **kwargs):
    matches = re.findall(r"\{.+?\}", value)
    formats = []
    for m in matches:
        value = value.replace(m, "%s")
        formats.append(m[1:-1])
    value = f"\"{value[1:-1]}\""
    code += f"({value}):format({", ".join(formats)})"
    return code

def compile_name(code, value, **kwargs):
    code += value
    return code

def compile_array(code, *values, **kwargs):
    code += f"{{{", ".join(values)}}}"
    return code

def compile_name_pattern(code, name, **kwargs):
    indent = "  " * kwargs["indent"]
    param_index = kwargs.get("param_index", 1)
    code += indent + f"local {name} = _args[{param_index}]"
    return code

def compile_array_pattern(code, *values, **kwargs):
    param_index = kwargs["param_index"]
    indent = "  " * kwargs["indent"]
    code += indent + "local "
    for i, val in enumerate(values):
        if isinstance(val, Tree):
            code += val.children[0]
        else:
            code += val
        if i < len(values) - 1:
            code += ", "
    code += "\n"
    code += indent + f"if getmetatable(_args[{param_index}]) and getmetatable(_args[{param_index}]).__args then\n"
    for i, val in enumerate(values):
        if isinstance(val, Tree) and val.data == "rest_pattern":
            code += indent + f"  {val.children[0]} = {{unpack(getmetatable(_args[{param_index}]).__args, {i + 1})}}\n"
        else:
            code += indent + f"  {val} = getmetatable(_args[{param_index}]).__args[{i + 1}]\n"
    code += indent + "else\n"    
    for i, val in enumerate(values):
        if isinstance(val, Tree) and val.data == "rest_pattern":
            code += indent + f"  {val.children[0]} = {{unpack(_args[{param_index}], {i + 1})}}\n"
        else:
            code += indent + f"  {val} = _args[{param_index}][{i + 1}]\n"
    code += indent + "end\n"
    return code

def compile_object_field(code, *args, **kwargs):
    indent = "  " * kwargs["indent"]
    if len(args) == 2:
        name, value = args
        code += f"{name} = "
        code = compile_tree(code, value, **kwargs)
    else:
        name, params, value = args
        code += f"{name} = function(...)\n"
        code += indent + "  local _args = {...}\n"
        kwargs["param_index"] = 0
        kwargs["indent"] += 1
        for p in params.children:
            kwargs["param_index"] += 1
            code = compile_tree(code, p, **kwargs)
        code += "\n"
        code += indent + "  return "
        code = compile_tree(code, value, **kwargs)
        code += "\n" + indent + "end"
    return code

def compile_object(code, *fields, **kwargs):
    indent = "  " * kwargs["indent"]
    code += "{\n"
    kwargs["indent"] += 1
    for i, f in enumerate(fields):
        code += indent + "  "
        code = compile_tree(code, f, **kwargs)
        code += ",\n"
    code += indent + "}"
    return code

def compile_table_field(code, key, value, **kwargs):
    code += "["
    code = compile_tree(code, key, **kwargs)
    code += "] = "
    code = compile_tree(code, value, **kwargs)
    return code

def compile_table(code, fields, **kwargs):
    code += "{"
    for i, f in enumerate(fields):
        code = compile_tree(code, f, **kwargs)
        if i < len(fields) < 1:
            code += ",\n"
    code += "}"
    return code

def compile_unary_expression(code, op, value, **kwargs):
    code += f"{op}"
    code = compile_tree(code, value, **kwargs)
    return code

def compile_binary_expression(code, left, op, right, **kwargs):
    code = compile_tree(code, left, **kwargs)
    code += f" {op} "
    code = compile_tree(code, right, **kwargs)
    return code

def compile_lambda_expression(code, params, body, **kwargs):
    indent = "  " * kwargs["indent"]
    code += "(function(_args)\n"
    code = compile_tree(code, params, **kwargs)
    code += indent + "  return "
    code = compile_tree(code, body, **kwargs)
    code += indent + "\nend)"
    return code

def compile_property_access(code, obj, prop, **kwargs):
    code += "("
    code = compile_tree(code, obj, **kwargs)
    code += ")."
    code = compile_tree(code, prop, **kwargs)
    return code

def compile_method_access(code, obj, method, args, **kwargs):
    code += "("
    code = compile_tree(code, obj, **kwargs)
    code += "):"
    code = compile_tree(code, method, **kwargs)
    code += "("
    for i, a in enumerate(args):
        code = compile_tree(code, a, **kwargs)
        if i < len(args) - 1:
            code += ", "
    code += ")"
    return code

def compile_variable_declaration(code, name, value, **kwargs):
    indent = "  " * kwargs["indent"]
    if name.data == "name_pattern":
        code += indent + f"local {name.children[0]} = "
        code = compile_tree(code, value, **kwargs)
        code += "\n"
    else:
        code += indent + "local _args = {"
        kwargs["indent"] += 1
        code = compile_tree(code, value, **kwargs)
        code += "}"
        code += "\n"
        kwargs["indent"] -= 1
        code = compile_tree(code, name, **kwargs)
    return code

def compile_struct_declaration(code, *args, **kwargs):
    indent = "  " * kwargs["indent"]
    if len(args) == 3:
        name, params, body = args
        kwargs["param_index"] = 0
        code += f"local function {name}(...)\n"
        code += indent + "  local _args = {...}\n"
        kwargs["indent"] += 1
        for p in params.children:
            kwargs["param_index"] += 1
            code = compile_tree(code, p, **kwargs)
            code += "\n"
        code += indent + "  return setmetatable("
        code = compile_tree(code, body, **kwargs)
        code += indent + ", {\n"
        code += indent + f"    __name = \"{name}\",\n"
        code += indent + "    __args = {...},\n"
        code += indent + "  })\n"
        code += indent + "end\n"
        return code
    name, body = args
    code += f"local {name} = "
    code = compile_tree(code, body, **kwargs)
    return code

def compile_function_declaration(code, name, params, body, **kwargs):
    indent = "  " * kwargs["indent"]
    kwargs["param_index"] = 0
    code += indent + f"local function {name}(...)\n"
    code += indent + "  local _args = {...}\n"
    kwargs["indent"] += 1
    for p in params.children:
        kwargs["param_index"] += 1
        code = compile_tree(code, p, **kwargs)
        code += "\n"
    code += indent + "  return "
    code = compile_tree(code, body, **kwargs)
    code += "\n"
    code += indent + "end\n"
    return code

def compile_function_call(code, func, args, **kwargs):
    is_sensitive = isinstance(func, Token) and func.type in ["NUMBER", "STRING"] or isinstance(func, Tree) and func.data in ["array", "object", "table"]
    if is_sensitive:
        code += "("
    code = compile_tree(code, func, **kwargs)
    if is_sensitive:
        code += ")"
    code += "("
    for i, a in enumerate(args.children):
        code = compile_tree(code, a, **kwargs)
        if i < len(args.children) - 1:
            code += ", "
    code += ")"
    return code

def compile_return_statement(code, expr, **kwargs):
    indent = "  " * kwargs["indent"]
    code += indent + "return "
    code = compile_tree(code, expr, **kwargs)
    code += "\n"
    return code

def compile_block(code, *stmts, **kwargs):
    indent = "  " * kwargs["indent"]
    code += "(function()\n"
    kwargs["indent"] += 1
    for s in stmts:
        code = compile_tree(code, s, **kwargs)
    code += indent + "end)()"
    return code

def compile_program(code, *stmts, **kwargs):
    for s in stmts:
        code = compile_tree(code, s, **kwargs)
        code += "\n"
    return code

def compile_tree(code, tree, **kwargs):
    if isinstance(tree, Token):
        if tree.type == "NUMBER":
            return compile_number(code, tree.value, **kwargs)
        if tree.type == "STRING":
            return compile_string(code, tree.value, **kwargs)
        if tree.type == "TEMPLATE_LITERAL":
            return compile_template_literal(code, tree.value, **kwargs)
        if tree.type == "NAME":
            return compile_name(code, tree.value, **kwargs)
        assert False, "Not implemented: '%s'" % tree.type
    if tree.data == "array":
        return compile_array(code, *tree.children, **kwargs)
    if tree.data == "name_pattern":
        return compile_name_pattern(code, *tree.children, **kwargs)
    if tree.data == "array_pattern":
        return compile_array_pattern(code, *tree.children, **kwargs)
    if tree.data == "object_field":
        return compile_object_field(code, *tree.children, **kwargs)
    if tree.data == "object":
        return compile_object(code, *tree.children, **kwargs)
    if tree.data == "table_field":
        return compile_table_field(code, *tree.children, **kwargs)
    if tree.data == "table":
        return compile_table(code, *tree.children, **kwargs)
    if tree.data == "unary_expression":
        return compile_unary_expression(code, *tree.children, **kwargs)
    if tree.data in ["mul_expression", "add_expression", "rel_expression", "eq_expression", "log_expression"]:
        return compile_binary_expression(code, *tree.children, **kwargs)
    if tree.data == "lambda_expression":
        return compile_lambda_expression(code, *tree.children, **kwargs)
    if tree.data == "property_access":
        return compile_property_access(code, *tree.children, **kwargs)
    if tree.data == "method_access":
        return compile_method_access(code, *tree.children, **kwargs)
    if tree.data == "variable_declaration":
        return compile_variable_declaration(code, *tree.children, **kwargs)
    if tree.data == "struct_declaration":
        return compile_struct_declaration(code, *tree.children, **kwargs)
    if tree.data == "function_declaration":
        return compile_function_declaration(code, *tree.children, **kwargs)
    if tree.data == "function_call":
        return compile_function_call(code, *tree.children, **kwargs)
    if tree.data == "return_statement":
        return compile_return_statement(code, *tree.children, **kwargs)
    if tree.data == "block":
        return compile_block(code, *tree.children, **kwargs)
    if tree.data == "program":
        return compile_program(code, *tree.children, **kwargs)
    if tree.data == "empty":
        return code
    assert False, "Not implemented: '%s'" % tree.data


def compile_source_code(source_code):
    tree = parser.parse(source_code)
    inlined_tree = inline_tree(tree)
    code = "require \"lib\"\n\n"
    code = compile_tree(code, inlined_tree, indent=0)
    return code


with open("main.lua") as f:
    text = f.read()

with open("out.lua", "w") as f:
    f.write(compile_source_code(text))