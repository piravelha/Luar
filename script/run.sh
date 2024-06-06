echo "[INFO] Compiling... (main.luar)"
python compiler.py && echo "[INFO] Done (out.lua)" && luajit out.lua