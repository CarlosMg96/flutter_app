import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/cubit/road_cubit.dart';
import '../../../data/model/road_model.dart';

class RoadListWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Roads'),
      ),
      body: BlocBuilder<RoadCubit, RoadState>(
        builder: (context, state) {
          if (state is RoadLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is RoadLoaded) {
            final roads = state.roads;
            return ListView.builder(
              itemCount: roads.length,
              itemBuilder: (context, index) {
                final road = roads[index];
                return ListTile(
                  title: Text(road.nombre),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Tipo: ${road.tipo}'),
                      Text('Longitud: ${road.longitud} KM'),
                      Text('Velocidad Máxima: ${road.velocidadMaxima} KM'),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          _showEditRoadDialog(context, road);
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          _showDeleteConfirmationDialog(context, road);
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          } else if (state is RoadError) {
            return Center(child: Text(state.message));
          }
          return Center(child: Text('No data available'));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddRoadDialog(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void _showAddRoadDialog(BuildContext context) {
    _showRoadDialog(context);
  }

  void _showEditRoadDialog(BuildContext context, Road road) {
    _showRoadDialog(context, road: road);
  }

  void _showRoadDialog(BuildContext context, {Road? road}) {
    final isEditing = road != null;
    final TextEditingController nombreController = TextEditingController(text: road?.nombre ?? '');
    final TextEditingController tipoController = TextEditingController(text: road?.tipo ?? '');
    final TextEditingController longitudController = TextEditingController(text: road?.longitud.toString() ?? '');
    final TextEditingController velocidadMaximaController = TextEditingController(text: road?.velocidadMaxima.toString() ?? '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isEditing ? 'Editar Carretera' : 'Agregar Carretera'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nombreController,
              decoration: InputDecoration(labelText: 'Nombre'),
            ),
            TextField(
              controller: tipoController,
              decoration: InputDecoration(labelText: 'Tipo'),
            ),
            TextField(
              controller: longitudController,
              decoration: InputDecoration(labelText: 'Longitud'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: velocidadMaximaController,
              decoration: InputDecoration(labelText: 'Velocidad Máxima'),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            child: Text('Cancelar'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text(isEditing ? 'Actualizar' : 'Agregar'),
            onPressed: () {
              final newRoad = Road(
                id: road?.id ?? 0, // Si es nuevo, el id no importa
                nombre: nombreController.text,
                tipo: tipoController.text,
                longitud: double.parse(longitudController.text),
                velocidadMaxima: double.parse(velocidadMaximaController.text),
              );

              if (isEditing) {
                BlocProvider.of<RoadCubit>(context).updateRoad(newRoad);
              } else {
                BlocProvider.of<RoadCubit>(context).createRoad(newRoad);
              }

              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, Road road) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirmar Borrado'),
        content: Text('¿Estás seguro de borrar esta carretera?'),
        actions: [
          TextButton(
            child: Text('Cancelar'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text('Borrar'),
            onPressed: () async {
              try {
                await BlocProvider.of<RoadCubit>(context).deleteRoad(road.id);
                Navigator.of(context).pop();
              } catch (e) {
                Navigator.of(context).pop();
                _showErrorDialog(context, 'Failed to delete road: $e');
              }
            },
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            child: Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}
