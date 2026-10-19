
import 'package:flutter/material.dart';

void main() {
  runApp(const MeuAplicativo());
}

// ==========================================
// PALETA DE CORES
// ==========================================

const Color verdeEscuro = Color(0xFF1E8449);
const Color roxo = Color(0xFF491E84);
const Color marrom = Color(0xFF84491E);
const Color verdeClaro = Color(0xFF58D68D);

// ==========================================
// APLICATIVO PRINCIPAL
// ==========================================

class MeuAplicativo extends StatelessWidget {
  const MeuAplicativo({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Meu Feed',
      theme: ThemeData(
        primaryColor: verdeEscuro,
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.fromSeed(
          seedColor: verdeEscuro,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: verdeEscuro,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        useMaterial3: true,
      ),
      home: const Feed(),
    );
  }
}

// ==========================================
// MODELO DE PUBLICAÇÃO
// ==========================================

class Publicacao {
  final String usuario;
  final String descricao;
  final String imagem;

  int curtidas;
  bool gostei;

  final List<String> comentarios;

  Publicacao({
    required this.usuario,
    required this.descricao,
    required this.imagem,
    required this.curtidas,
    this.gostei = false,
    List<String>? comentarios,
  }) : comentarios = comentarios ?? [];
}

// ==========================================
// TELA PRINCIPAL
// ==========================================

class Feed extends StatefulWidget {
  const Feed({super.key});

  @override
  State<Feed> createState() => _FeedState();
}

class _FeedState extends State<Feed> {
  int paginaAtual = 0;

  final TextEditingController descricaoController =
      TextEditingController();

  final List<Publicacao> publicacoes = [
    Publicacao(
      usuario: 'Daniel',
      descricao: 'Conhecendo novos lugares! 🌿',
      imagem:
          'https://i.scdn.co/image/ab67616100005174f37f1526fcb538d984c85cbc?w=800',
      curtidas: 12,
    ),
    Publicacao(
      usuario: 'Luan',
      descricao: 'Um dia incrível para explorar! ☀️',
      imagem:
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQOpdj8yXU4AQeVEGyaVu4EcxOrEx0z5sE8xgqgcaEP0w&s=10',
      curtidas: 25,
    ),
    Publicacao(
      usuario: 'Nickolas',
      descricao: 'A natureza sempre surpreende. 🍃',
      imagem:
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTShkwincRGVU6cVuCoeEFI_wwIAeV-Hrnf2F0i-9gHOA&s=10',
      curtidas: 8,
    ),
  ];

  @override
  void dispose() {
    descricaoController.dispose();
    super.dispose();
  }

  // ==========================================
  // CURTIR PUBLICAÇÃO
  // ==========================================

  void curtir(Publicacao publicacao) {
    setState(() {
      publicacao.gostei = !publicacao.gostei;

      if (publicacao.gostei) {
        publicacao.curtidas++;
      } else {
        publicacao.curtidas--;
      }
    });
  }

  // ==========================================
  // COMENTÁRIOS
  // ==========================================

  void abrirComentarios(Publicacao publicacao) {
    final TextEditingController comentarioController =
        TextEditingController();

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, atualizarModal) {
            return Padding(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 20,
                bottom:
                    MediaQuery.of(context).viewInsets.bottom + 20,
              ),
              child: SafeArea(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Comentários',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: verdeEscuro,
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 220,
                      child: publicacao.comentarios.isEmpty
                          ? const Center(
                              child: Text(
                                'Nenhum comentário ainda.',
                              ),
                            )
                          : ListView.builder(
                              itemCount:
                                  publicacao.comentarios.length,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  leading: const CircleAvatar(
                                    backgroundColor: verdeClaro,
                                    child: Icon(
                                      Icons.person,
                                      color: verdeEscuro,
                                    ),
                                  ),
                                  title: Text(
                                    publicacao
                                        .comentarios[index],
                                  ),
                                );
                              },
                            ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: comentarioController,
                            decoration: const InputDecoration(
                              hintText: 'Escreva um comentário...',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.send,
                            color: verdeEscuro,
                          ),
                          onPressed: () {
                            final texto =
                                comentarioController.text.trim();

                            if (texto.isEmpty) return;

                            setState(() {
                              publicacao.comentarios.add(texto);
                            });

                            comentarioController.clear();
                            atualizarModal(() {});
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    ).whenComplete(comentarioController.dispose);
  }

  // ==========================================
  // COMPARTILHAR
  // ==========================================

  void compartilhar() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Compartilhamento demonstrativo.',
        ),
      ),
    );
  }

  // ==========================================
  // ADICIONAR PUBLICAÇÃO
  // ==========================================

  void publicar() {
    final String descricao =
        descricaoController.text.trim();

    if (descricao.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Digite uma descrição para publicar.'),
        ),
      );
      return;
    }

    setState(() {
      publicacoes.insert(
        0,
        Publicacao(
          usuario: 'meu_perfil',
          descricao: descricao,
          imagem:
              'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?w=800',
          curtidas: 0,
        ),
      );

      descricaoController.clear();
      paginaAtual = 0;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Publicação adicionada com sucesso!'),
      ),
    );
  }

  // ==========================================
  // TELA FEED
  // ==========================================

  Widget construirFeed() {
    return ListView.builder(
      padding: const EdgeInsets.only(top: 8),
      itemCount: publicacoes.length,
      itemBuilder: (context, index) {
        final Publicacao publicacao = publicacoes[index];

        return Card(
          margin: const EdgeInsets.only(
            left: 8,
            right: 8,
            bottom: 12,
          ),
          elevation: 1,
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                leading: const CircleAvatar(
                  backgroundColor: verdeClaro,
                  child: Icon(
                    Icons.person,
                    color: verdeEscuro,
                  ),
                ),
                title: Text(
                  publicacao.usuario,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.more_vert),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Opções da publicação',
                        ),
                      ),
                    );
                  },
                ),
              ),

              // IMAGEM DA PUBLICAÇÃO

              Image.network(
                publicacao.imagem,
                width: double.infinity,
                height: 260,
                fit: BoxFit.cover,
                loadingBuilder:
                    (context, child, loadingProgress) {
                  if (loadingProgress == null) {
                    return child;
                  }

                  return const SizedBox(
                    height: 260,
                    child: Center(
                      child: CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation<Color>(
                          verdeEscuro,
                        ),
                      ),
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return const SizedBox(
                    height: 260,
                    child: Center(
                      child: Icon(
                        Icons.broken_image,
                        size: 50,
                        color: marrom,
                      ),
                    ),
                  );
                },
              ),

              // BOTÕES DE INTERAÇÃO

              Row(
                children: [
                  IconButton(
                    tooltip: 'Curtir',
                    onPressed: () => curtir(publicacao),
                    icon: Icon(
                      publicacao.gostei
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: publicacao.gostei
                          ? Colors.red
                          : roxo,
                    ),
                  ),
                  IconButton(
                    tooltip: 'Comentar',
                    onPressed: () {
                      abrirComentarios(publicacao);
                    },
                    icon: const Icon(
                      Icons.mode_comment_outlined,
                      color: roxo,
                    ),
                  ),
                  IconButton(
                    tooltip: 'Compartilhar',
                    onPressed: compartilhar,
                    icon: const Icon(
                      Icons.share_outlined,
                      color: marrom,
                    ),
                  ),
                ],
              ),

              // TOTAL DE CURTIDAS

              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                ),
                child: Text(
                  '${publicacao.curtidas} curtidas',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              // DESCRIÇÃO

              Padding(
                padding: const EdgeInsets.fromLTRB(
                  16,
                  8,
                  16,
                  16,
                ),
                child: RichText(
                  text: TextSpan(
                    style: DefaultTextStyle.of(context).style,
                    children: [
                      TextSpan(
                        text: '${publicacao.usuario} ',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: publicacao.descricao,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ==========================================
  // TELA EXPLORAR
  // ==========================================

  Widget construirExplorar() {
    return GridView.builder(
      padding: const EdgeInsets.all(4),
      itemCount: publicacoes.length,
      gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 4,
        mainAxisSpacing: 4,
      ),
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            setState(() {
              paginaAtual = 0;
            });
          },
          child: Image.network(
            publicacoes[index].imagem,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return const ColoredBox(
                color: verdeClaro,
                child: Icon(Icons.image_not_supported),
              );
            },
          ),
        );
      },
    );
  }

  // ==========================================
  // TELA PUBLICAR
  // ==========================================

  Widget construirPublicar() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Criar publicação',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: verdeEscuro,
            ),
          ),
          const SizedBox(height: 20),
          const Icon(
            Icons.add_a_photo_outlined,
            size: 80,
            color: verdeClaro,
          ),
          const SizedBox(height: 20),
          TextField(
            controller: descricaoController,
            maxLines: 4,
            decoration: const InputDecoration(
              labelText: 'Descrição',
              hintText: 'O que você deseja compartilhar?',
              border: OutlineInputBorder(),
              alignLabelWithHint: true,
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: publicar,
            icon: const Icon(Icons.send),
            label: const Text('Publicar'),
            style: ElevatedButton.styleFrom(
              backgroundColor: verdeEscuro,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.all(16),
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Esta versão utiliza uma imagem de demonstração '
            'para as novas publicações.',
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // ==========================================
  // TELA PERFIL
  // ==========================================

  Widget construirPerfil() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundColor: verdeClaro,
              child: Icon(
                Icons.person,
                size: 60,
                color: verdeEscuro,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'meu_perfil',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${publicacoes.length} publicações',
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  paginaAtual = 2;
                });
              },
              icon: const Icon(Icons.add),
              label: const Text('Nova publicação'),
              style: ElevatedButton.styleFrom(
                backgroundColor: verdeEscuro,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // CONSTRUÇÃO DA INTERFACE
  // ==========================================

  @override
  Widget build(BuildContext context) {
    const List<String> titulos = [
      'Meu Feed',
      'Explorar',
      'Publicar',
      'Meu Perfil',
    ];

    final List<Widget> telas = [
      construirFeed(),
      construirExplorar(),
      construirPublicar(),
      construirPerfil(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(titulos[paginaAtual]),
        centerTitle: false,
      ),
      body: IndexedStack(
        index: paginaAtual,
        children: telas,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: paginaAtual,
        backgroundColor: Colors.white,
        indicatorColor: verdeClaro,
        onDestinationSelected: (int index) {
          setState(() {
            paginaAtual = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(
              Icons.home,
              color: verdeEscuro,
            ),
            label: 'Feed',
          ),
          NavigationDestination(
            icon: Icon(Icons.search),
            selectedIcon: Icon(
              Icons.search,
              color: verdeEscuro,
            ),
            label: 'Explorar',
          ),
          NavigationDestination(
            icon: Icon(Icons.add_box_outlined),
            selectedIcon: Icon(
              Icons.add_box,
              color: verdeEscuro,
            ),
            label: 'Publicar',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(
              Icons.person,
              color: verdeEscuro,
            ),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}

