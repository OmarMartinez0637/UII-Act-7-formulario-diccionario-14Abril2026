import 'claseempleado.dart';
import 'diccionarioempleado.dart';

class GuardarDatosDiccionario {
  // Función nivel principiante para encapsular la labor de guardar
  static void guardarEmpleado({
    required String nombre,
    required String puesto,
    required double salario,
  }) {
    // Generar id autonumérico
    int nuevoId = generarId();
    
    // Instanciar el objeto Empleado
    Empleado nuevoEmpleado = Empleado(
      id: nuevoId,
      nombre: nombre,
      puesto: puesto,
      salario: salario,
    );
    
    // Guardar en el diccionario usando el ID como clave
    datosempleado[nuevoId] = nuevoEmpleado;
  }
}
