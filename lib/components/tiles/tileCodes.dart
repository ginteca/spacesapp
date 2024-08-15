import 'package:flutter/material.dart';

Widget TileCodes({
  required BuildContext context, // Añadir BuildContext como parámetro
  required String codigo,
  required String fechaCreado,
  required String fechaValidado,
  required String fechaSalida,
  required String observaciones,
  // required List<Map<String, String>> validaciones,
}) {
  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: Container(
      
      decoration: BoxDecoration(
        color: Colors.grey[350],
        borderRadius: BorderRadius.circular(16.0), // Ajusta el radio según lo necesites
      ),
      child: ExpansionTile(
        backgroundColor: Colors.transparent, // Para que se vea el color del Container
        collapsedBackgroundColor: Colors.transparent, // Para que se vea el color del Container
        title: Container(
          height: MediaQuery.of(context).size.height * 0.15,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Código de visita:',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Salida $codigo',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.purple,
                ),
              ),
              Text(
                'Válido hasta: $fechaValidado',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.black54,
                ),
              ),
              SizedBox(height: 10,),
              Text(observaciones,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
              )
            ],
          ),
        ),
        trailing: Icon(Icons.close),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Creado el:',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      fechaCreado,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Validado el:',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      fechaValidado,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Salida:',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      fechaSalida,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Observaciones:',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(width: 4),
                    Text(
                      observaciones,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Table(
                  columnWidths: const {
                    0: FlexColumnWidth(3),
                    1: FlexColumnWidth(2),
                    2: FlexColumnWidth(3),
                    3: FlexColumnWidth(2),
                  },
                  // children: validaciones.map((validacion) {
                  //   return TableRow(
                  //     children: [
                  //       Text(
                  //         validacion['descripcion'] ?? '',
                  //         style: TextStyle(fontSize: 12, color: Colors.black),
                  //       ),
                  //       SizedBox.shrink(),
                  //       Text(
                  //         validacion['fecha'] ?? '',
                  //         style: TextStyle(fontSize: 12, color: Colors.black),
                  //       ),
                  //       SizedBox.shrink(),
                  //     ],
                  //   );
                  // }).toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
