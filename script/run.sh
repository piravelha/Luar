echo "[INFO] Compiling... (main.luar)"
pypy3 compiler.py && echo "[INFO] Done (out.lua)" && luajit out.lua