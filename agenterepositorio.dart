import 'dart:io';

Future<void> main() async {
  print('====================================================');
  print('             AGENTE REPOSITORIO DE GITHUB           ');
  print('====================================================\n');

  // 1. Comprobar si git está instalado
  var checkGit = await Process.run('git', ['--version']);
  if (checkGit.exitCode != 0) {
    print('❌ Error: Git no está instalado o no se encuentra en tus variables de entorno PATH.');
    return;
  }

  // 2. Inicializar el repositorio si es necesario
  print('🔍 Verificando estado del repositorio local...');
  var checkStatus = await Process.run('git', ['status']);
  if (checkStatus.exitCode != 0) {
    print('⚙️ Inicializando repositorio local vacío (git init)...');
    await _mostrarProceso('git', ['init']);
  } else {
    print('✅ El repositorio ya está inicializado.');
  }

  // 3. Manejar el link de GitHub (remote origin)
  stdout.write('\n🔗 Introduce el enlace de tu repositorio de GitHub (.git)\n(O deja en blanco, presiona Enter, para mantener el actual si ya existe): ');
  String? url = stdin.readLineSync()?.trim();

  if (url != null && url.isNotEmpty) {
    var checkRemote = await Process.run('git', ['remote', 'get-url', 'origin']);
    if (checkRemote.exitCode == 0) {
      await _mostrarProceso('git', ['remote', 'set-url', 'origin', url]);
      print('🌐 Origen "origin" actualizado al nuevo enlace.');
    } else {
      await _mostrarProceso('git', ['remote', 'add', 'origin', url]);
      print('🌐 Origen "origin" agregado exitosamente.');
    }
  }

  // 4. Agregar archivos
  print('\n📦 Agregando todos los archivos al área de preparación (git add .)...');
  await _mostrarProceso('git', ['add', '.']);

  // 5. Generar un commit
  stdout.write('\n📝 Introduce el mensaje de tu commit: ');
  String? commitMsg = stdin.readLineSync()?.trim();
  if (commitMsg == null || commitMsg.isEmpty) {
    commitMsg = 'Actualización automática del proyecto';
    print('⚠️ Se asignará el mensaje por defecto: "$commitMsg"');
  }
  await _mostrarProceso('git', ['commit', '-m', commitMsg]);

  // 6. Preparar rama
  stdout.write('\n🌿 ¿A qué rama deseas subir los cambios? [Por defecto: main]: ');
  String? rama = stdin.readLineSync()?.trim();
  if (rama == null || rama.isEmpty) {
    rama = 'main';
  }
  await _mostrarProceso('git', ['branch', '-M', rama]);

  // 7. Push hacia GitHub
  print('\n🚀 Subiendo cambios a la rama "$rama" en origin...');
  var pushProcess = await Process.start('git', ['push', '-u', 'origin', rama]);
  
  // Imprimimos el stream en vivo de git push
  await stdout.addStream(pushProcess.stdout);
  await stderr.addStream(pushProcess.stderr);

  var exitCode = await pushProcess.exitCode;
  
  print('\n====================================================');
  if (exitCode == 0) {
    print('  🎉 ¡Proyecto subido exitosamente a GitHub!');
  } else {
    print('  ❌ Ocurrió un error al intentar subir a GitHub.');
  }
  print('====================================================\n');
}

/// Función auxiliar para ejecutar procesos y manejar salidas de error comunes.
Future<void> _mostrarProceso(String executable, List<String> arguments) async {
  var result = await Process.run(executable, arguments);
  if (result.exitCode != 0) {
    // Si la salida de error indica que no hay nada para hacer commit, lo mostramos suavemente
    if (result.stdout.toString().contains('nothing to commit')) {
      print('ℹ️ No hay cambios pendientes por hacer commit.');
    } else {
      print('⚠️ Mensaje del sistema: \n${result.stderr.toString().trim()}');
      print(result.stdout.toString().trim());
    }
  }
}
