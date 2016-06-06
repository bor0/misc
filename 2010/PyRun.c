#include <Python.h>

void exec_pycode(const char* code);

int main() {
char x[512];
gets(x);
exec_pycode(x);
return 0;
}

void exec_pycode(const char* code) {
Py_Initialize();
PyRun_SimpleString(code);
Py_Finalize();
}
