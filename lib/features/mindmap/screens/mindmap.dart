import 'dart:math';
import 'package:flutter/material.dart';
import 'package:graphview/GraphView.dart';
import 'package:skillsync/db/Models/Lesson.dart';
import 'package:skillsync/db/SKDataBase.dart';
import 'package:skillsync/db/Models/Topic.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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

    algorithm = BuchheimWalkerAlgorithm(
      BuchheimWalkerConfiguration(
        siblingSeparation: 50,
        levelSeparation: 50,
        subtreeSeparation: 50,
        orientation: BuchheimWalkerConfiguration.ORIENTATION_TOP_BOTTOM,
      ),
      null,
    );

    _loadData();
  }

  //carga de datos de la base de datos
  Future<void> _loadData() async {
    final db = await AppDatabase.initDB();
    final results = await Future.wait([db.query('topic'), db.query('lesson')]);

    // Evita que se llame setState si el widget ya fue desmontado
    if (!mounted) return;

    final topicResult = results[0];
    final lessonResult = results[1];

    topics = topicResult.map((e) => Topic.fromMap(e)).toList();
    lessons = lessonResult.map((e) => Lesson.fromMap(e)).toList();

    // grafo INMEDIATAMENTE después de cargar datos

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final l10n = AppLocalizations.of(context);
      if (l10n != null) {
        _buildGraph(l10n.graphRootTitle);

        if (mounted) {
          setState(() {
            isLoading = false;
          });
        }
      }
    });
  }

  // construcion del grafo
  void _buildGraph(String rootTitle) {
    graph.nodes.clear();
    graph.edges.clear();
    topicNodes.clear();
    lessonNodes.clear();

    // Nodo raíz central
    final rootNode = Node.Id(rootTitle);
    graph.addNode(rootNode);

    // Si no hay topics, el grafo solo tendrá el nodo raíz
    if (topics.isEmpty) {
      print('NO DATABASE');
      return;
    }

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
      if (topic.id != null) {
        topicNodes[topic.id!] = topicNode; // solo si existe el id
      }

      // Crear nodos por cada Lesson que pertenezca a Topic
      final topicLessons =
          lessons
              .where((l) => l.categoryId == topic.id)
              .toList(); //filtracion de que pertenezca al topic
      for (final lesson in topicLessons) {
        final lessonNode = Node.Id(
          lesson.title,
        ); //crea un nodo con el titulo de cada uno
        graph.addNode(lessonNode); //añade el nodo al grafo
        graph.addEdge(
          topicNode,
          lessonNode,
        ); //agrega la conexion entre el tema principal y el nodo
        if (lesson.id != null) {
          lessonNodes[lesson.id!] = lessonNode; //no crear si id es nulo
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
  void dispose() {
    // Limpieza al salir de la pantalla para evitar renderizados pendientes
    graph.nodes.clear();
    graph.edges.clear();
    topicNodes.clear();
    lessonNodes.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

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
          l10n.mindMapTitle,
          style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
        ),
        backgroundColor: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
        iconTheme: IconThemeData(
          color: isDarkMode ? Colors.white : Colors.black,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (!mounted) return;
            context.go('/mainmenu');
          },
        ),
      ),
      backgroundColor: backgroundColor,
      body:
          isLoading
              ? Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(),
                    const SizedBox(height: 12),
                    Text(l10n.loadingMessage),
                  ],
                ),
              )
              // Mostrar mensaje si no hay datos
              : topics.isEmpty
              ? Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.folder_open,
                      size: 80,
                      color: isDarkMode ? Colors.white38 : Colors.black38,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No hay temas disponibles',
                      style: TextStyle(
                        fontSize: 18,
                        color: isDarkMode ? Colors.white70 : Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Agrega temas para ver tu mapa mental',
                      style: TextStyle(
                        fontSize: 14,
                        color: isDarkMode ? Colors.white54 : Colors.black54,
                      ),
                    ),
                  ],
                ),
              )
              : LayoutBuilder(
                builder: (context, constraints) {
                  return InteractiveViewer(
                    constrained: false,
                    boundaryMargin: const EdgeInsets.all(100),
                    minScale: 0.01,
                    maxScale: 5.0,
                    child: Center(
                      child: SizedBox(
                        width: max(constraints.maxWidth, 600),
                        height: max(constraints.maxHeight, 600),
                        child: GraphView(
                          graph: graph,
                          algorithm: algorithm,
                          paint:
                              Paint()
                                ..color =
                                    isDarkMode ? Colors.white70 : Colors.blue
                                ..strokeWidth = 1
                                ..style = PaintingStyle.stroke,
                          builder: (Node node) {
                            final label =
                                node.key?.value?.toString() ??
                                l10n.graphNodeDefaultLabel;

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
                                    : 0;

                            return GestureDetector(
                              onTap: () {
                                if (!mounted) return;
                                if (isTopic) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        l10n.snackbarTopicProgress(
                                          label,
                                          progress,
                                        ),
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
                                            : const Color.fromARGB(
                                              255,
                                              240,
                                              240,
                                              240,
                                            ))
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
                                          isTopic
                                              ? FontWeight.bold
                                              : FontWeight.normal,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  );
                },
              ),
    );
  }
}
