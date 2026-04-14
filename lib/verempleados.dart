import 'package:flutter/material.dart';
import 'claseempleado.dart';
import 'diccionarioempleado.dart';

class VerEmpleados extends StatefulWidget {
  const VerEmpleados({super.key});

  @override
  State<VerEmpleados> createState() => _VerEmpleadosState();
}

class _VerEmpleadosState extends State<VerEmpleados> {
  @override
  Widget build(BuildContext context) {
    // Obtenemos la lista de valores del diccionario
    List<Empleado> empleadosList = datosempleado.values.toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Empleados'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: empleadosList.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.people_outline, size: 80, color: Colors.grey.shade400),
                  const SizedBox(height: 20),
                  const Text(
                    'No hay empleados registrados.',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: empleadosList.length,
              itemBuilder: (context, index) {
                Empleado emp = empleadosList[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    leading: CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.teal.shade100,
                      child: Text(
                        '#${emp.id}',
                        style: TextStyle(
                          color: Colors.teal.shade900, 
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                    title: Text(
                      emp.nombre,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold, 
                        fontSize: 18
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            const Icon(Icons.work, size: 16, color: Colors.grey),
                            const SizedBox(width: 5),
                            Text('Puesto: ${emp.puesto}'),
                          ],
                        ),
                        const SizedBox(height: 3),
                        Row(
                          children: [
                            const Icon(Icons.monetization_on, size: 16, color: Colors.green),
                            const SizedBox(width: 5),
                            Text(
                              'Salario: \$${emp.salario.toStringAsFixed(2)}',
                              style: const TextStyle(
                                color: Colors.green, 
                                fontWeight: FontWeight.bold
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
