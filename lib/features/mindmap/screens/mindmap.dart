import 'package:flutter/material.dart';
import 'package:graphview/GraphView.dart';
import 'package:skillsync/db/Models/Lesson.dart';
import 'package:skillsync/db/SKDataBase.dart';
import 'package:skillsync/db/Models/Topic.dart';
import 'package:go_router/go_router.dart';

class MindMap extends StatefulWidget {
  const MindMap({super.key});

  @override
  State<MindMap> createState() => _MindMapState();
}

class _MindMapState extends State<MindMap> {
  final Graph graph =
      Graph(); //funcion de graphview para crear el lienzo del mapa
  late Algorithm algorithm;

  final Map<int, Node> topicNodes =
      {}; //lista de nodos de los topics que se identifican segun el id que tiene
  final Map<int, Node> lessonNodes = {}; //aplica lo mismo para lecciones

  List<Topic> topics = [];
  List<Lesson> lessons = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    algorithm = FruchtermanReingoldAlgorithm(
      FruchtermanReingoldConfiguration(),
    );
    _loadData();
  }

  //carga de datos de la base de datos
  Future<void> _loadData() async {
    final db = await AppDatabase.initDB();
    final results = await Future.wait([db.query('topic'), db.query('lesson')]);

    final topicResult = results[0];
    final lessonResult = results[1];

    setState(() {
      topics = topicResult.map((e) => Topic.fromMap(e)).toList();
      lessons = lessonResult.map((e) => Lesson.fromMap(e)).toList();
      isLoading = false;
      _buildGraph(); // se crea todo a partir de si se creo el gtrafo importante debido a que sin grafo no existiria grafica
    });
  }

  // construcion del grafo
  void _buildGraph() {
    graph.nodes.clear();
    graph.edges.clear();
    topicNodes.clear();
    lessonNodes.clear();

    // Nodo raíz central
    final rootNode = Node.Id('Temas');
    graph.addNode(rootNode);

    // Crear nodos por cada Topic
    for (final topic in topics) {
      final topicNode = Node.Id(
        topic.title,
      ); //crear nodo para cada tema con el titulo
      graph.addNode(topicNode); //añade tema a el grafo
      graph.addEdge(
        rootNode,
        topicNode,
      ); //crea conexion entre el nodo princpial y este
      if (topic.id == null) {
        topicNodes[topic.id!] = topicNode; //no se crea si este no existe
      }

      // Crear nodos por cada Lesson que pertenezca a  Topic
      final topicLessons =
          lessons
              .where((l) => l.categoryId == topic.id)
              .toList(); //filtracio de que pertenezca a el topic
      for (final lesson in topicLessons) {
        final lessonNode = Node.Id(
          lesson.title,
        ); //crea un nodo con el titulo de cada uno
        graph.addNode(lessonNode); //añade el nodo a el grafo
        graph.addEdge(
          topicNode,
          lessonNode,
        ); //agrega la conexion entre el tema principal y el nodo
        if (lesson.id == null) {
          lessonNodes[topic.id!] = lessonNode; //no lo creara si no existe
        }
      }
    }
  }

  // calcular porcentaje
  int calculateProgressForTopic(int topicId) {
    final topicLessons = lessons.where((l) => l.categoryId == topicId).toList();
    if (topicLessons.isEmpty) return 0;

    final completed = topicLessons.where((l) => l.state == true).length;
    final percentage = (completed / topicLessons.length * 100).round();
    return percentage;
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode =
        Theme.of(context).brightness ==
        Brightness.dark; // detectar si está en modo oscuro
    final backgroundColor =
        isDarkMode ? const Color(0xFF121212) : const Color(0xFFF0FAFC);
    final cardTopicColor = isDarkMode ? const Color(0xFF1E1E1E) : Colors.white;
    final textColor = isDarkMode ? Colors.white : Colors.black87;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Mapa Mental',
          style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
        ),
        backgroundColor: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
        iconTheme: IconThemeData(
          color: isDarkMode ? Colors.white : Colors.black,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.go('/mainmenu');
          },
        ),
      ),
      backgroundColor: backgroundColor,
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : InteractiveViewer(
                constrained: false,
                boundaryMargin: const EdgeInsets.all(100),
                minScale: 0.01,
                maxScale: 5.0,
                child: GraphView(
                  graph: graph,
                  algorithm: algorithm,
                  paint:
                      Paint()
                        ..color =
                            isDarkMode
                                ? Colors.white70
                                : Colors
                                    .blue // cambia el color de líneas
                        ..strokeWidth = 1
                        ..style = PaintingStyle.stroke,
                  builder: (Node node) {
                    final label = node.key?.value?.toString() ?? 'Node';

                    // Detectar si es un topic para mostrar porcentaje
                    final topic = topics.firstWhere(
                      (t) => t.title == label,
                      orElse:
                          () => Topic(
                            id: -1,
                            title: '',
                            content: '',
                            date: '',
                            state: false,
                          ),
                    );

                    final isTopic = topic.id != -1;
                    final progress =
                        (isTopic && topic.id != null)
                            ? calculateProgressForTopic(topic.id!)
                            : null;

                    return GestureDetector(
                      onTap: () {
                        if (!mounted) return;
                        if (isTopic) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Tema: $label\nProgreso: $progress%',
                              ),
                            ),
                          );
                        }
                      },
                      child: Card(
                        color:
                            isTopic
                                ? (isDarkMode
                                    ? const Color(0xFF252525)
                                    : const Color.fromARGB(255, 240, 240, 240))
                                : cardTopicColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: isDarkMode ? 2 : 4,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            isTopic ? '$label ($progress%)' : label,
                            style: TextStyle(
                              color: textColor,
                              fontWeight:
                                  isTopic ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
    );
  }
}
