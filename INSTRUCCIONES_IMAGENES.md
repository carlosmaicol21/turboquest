# Instrucciones para Extraer las Imágenes

## Problema
La carpeta `assets/images` está vacía y las imágenes están comprimidas en el archivo `imagenes.rar`.

## Solución

### Opción 1: Extraer Manualmente (Recomendado)

1. **Instala WinRAR o 7-Zip** si no lo tienes:
   - WinRAR: https://www.win-rar.com/
   - 7-Zip: https://www.7-zip.org/

2. **Extrae el archivo**:
   - Haz clic derecho en `imagenes.rar`
   - Selecciona "Extraer aquí" o "Extract Here"
   - Esto creará carpetas con las imágenes

3. **Organiza las carpetas**:
   - Mueve todas las carpetas extraídas dentro de `assets/images/`
   - La estructura final debe ser:
     ```
     assets/
       images/
         imagenBo1.png
         imagenBo2.png
         ...
         imagenBo31.png
         bolivia/
           imagenBo32.png
           ...
           imagenBo40.png
         oruro/
           1.png
           2.jpeg
           3.png
           ...
           42.png
         logo_catec.png
     ```

### Opción 2: Usar Script PowerShell (si tienes WinRAR)

Ejecuta este comando en PowerShell en la carpeta del proyecto:
```powershell
& "C:\Program Files\WinRAR\WinRAR.exe" x imagenes.rar assets\images\
```

### Opción 3: Usar Script PowerShell (si tienes 7-Zip)

Ejecuta este comando en PowerShell en la carpeta del proyecto:
```powershell
& "C:\Program Files\7-Zip\7z.exe" x imagenes.rar -oassets\images -y
```

## Verificación

Después de extraer las imágenes, verifica que:
1. La carpeta `assets/images` no esté vacía
2. Ejecuta `flutter pub get` para asegurar que Flutter reconozca los nuevos assets
3. Ejecuta la aplicación para verificar que las imágenes carguen correctamente

## Notas

- Si alguna imagen sigue sin cargar, el código mostrará un placeholder con el mensaje "Imagen no disponible"
- Las imágenes duplicadas han sido corregidas en el código
- La aplicación ahora maneja mejor los errores de carga de imágenes
