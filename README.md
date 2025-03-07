# Sistema Gerenciador de Eventos - Front-End (Flutter)

Este repositório contém o código-fonte do front-end do sistema gerenciador de eventos, desenvolvido utilizando o framework **Flutter**. O front-end é responsável pela interface do usuário, permitindo que alunos visualizem eventos, realizem inscrições e anexem documentos, enquanto os professores gerenciam eventos e aprovam inscrições.

## Tecnologias Utilizadas
- **Flutter**: Framework para desenvolvimento de interfaces multiplataforma.
- **Dart**: Linguagem de programação utilizada pelo Flutter.
- **HTTP**: Para comunicação com a API do back-end.

## Como Executar o Projeto

### Pré-requisitos
- **Flutter SDK**: Certifique-se de ter o Flutter instalado. Siga as instruções em [flutter.dev](https://flutter.dev).
- **Android Studio/VSCode**: Para desenvolvimento e execução do projeto.

### Passos para Execução
1. Clone este repositório:
   ```bash
   git clone https://github.com/seu-usuario/frontend-eventos.git

2. Navegue até a pasta do projeto:

   ```bash
   cd frontend-eventos

3. Instale as dependências:

   ```bash
   flutter pub get
4. Execute o projeto:

   ```bash
   flutter run

---

### **Estrutura do Projeto**

```markdown
## Estrutura do Projeto
- `lib/app`: Contém o código-fonte principal do aplicativo.
  - `main.dart`: Ponto de entrada do aplicativo.
  - `ui/web/`: Telas do aplicativo (ex: tela de login, dashboard, eventos).
  - `ui/web/widgets//`: Componentes reutilizáveis.
  - `api.dart/`: Serviços para comunicação com a API do back-end.
