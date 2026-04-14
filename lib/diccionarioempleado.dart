import 'claseempleado.dart';

// Diccionario vacío global
Map<int, Empleado> datosempleado = {};

// Variable para generar id autonumérico
int _currentId = 1;

int generarId() {
  int id = _currentId;
  _currentId++;
  return id;
}
