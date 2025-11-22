# Ciganus - Baralho Cigano iOS App

Ciganus é um aplicativo iOS desenvolvido em SwiftUI para leitura e estudo do Baralho Cigano. O projeto foca em uma arquitetura robusta, escalável e preparada para produção, oferecendo suporte offline e sincronização inteligente de dados.

## 📱 Funcionalidades

- **Autenticação Segura**: Login e Registro via Firebase Auth.
- **Catálogo de Cartas**: Visualização detalhada das 36 cartas do baralho cigano.
- **Modo Offline (Offline-First)**: As cartas são salvas localmente usando **SwiftData**, permitindo acesso instantâneo mesmo sem internet.
- **Sincronização Inteligente**: O app verifica atualizações no servidor (Firebase Realtime Database) e sincroniza apenas quando necessário, economizando dados e bateria.
- **Design System**: Interface moderna e consistente com componentes reutilizáveis (`PrimaryButton`, `CustomTextField`, `AppBackground`).
- **Navegação Centralizada**: Gerenciamento de fluxo via **Coordinator Pattern**.

## 🛠 Arquitetura e Tecnologias

O projeto segue o padrão **MVVM-C (Model-View-ViewModel + Coordinator)** com ênfase em Clean Code e SOLID.

- **Linguagem**: Swift 5.9+
- **UI Framework**: SwiftUI
- **Persistência Local**: SwiftData (`@Model`)
- **Backend**: Firebase (Auth & Realtime Database)
- **Gerenciamento de Dependências**: Swift Package Manager (SPM)

### Destaques Técnicos

- **Dependency Injection (DI)**: ViewModels recebem dependências via protocolos (`AuthServicing`, `CardServicing`), facilitando testes.
- **Concurrency**: Uso extensivo de `async/await` e `@MainActor` para segurança de threads.
- **Coordinator Pattern**: Separação da lógica de navegação das Views, tornando o fluxo mais flexível e testável.
- **SyncService**: Serviço dedicado para gerenciar a versão dos dados e a sincronização entre local (SwiftData) e remoto (Firebase).
- **Testes Unitários**: Cobertura de testes para ViewModels e utilitários usando XCTest e Mocks.

## 📂 Estrutura do Projeto

```
Ciganus/
├── App/
│   ├── CiganusApp.swift       # Ponto de entrada e configuração do SwiftData
│   └── AppDelegate.swift      # Configuração do Firebase
├── Coordinator/
│   └── AppCoordinator.swift   # Gerenciador de navegação
├── Model/
│   ├── Card.swift             # Modelo de dados (SwiftData)
│   └── AppError.swift         # Tratamento de erros centralizado
├── Service/
│   ├── AuthService.swift      # Autenticação Firebase
│   ├── CardService.swift      # Acesso a dados (Facade)
│   └── SyncService.swift      # Lógica de sincronização
├── View/
│   ├── Components/            # Componentes reutilizáveis (Design System)
│   ├── Login/                 # Telas de Autenticação
│   ├── Main/                  # Tela Principal
│   └── Theme/                 # Cores e Fontes centralizadas
├── ViewModel/
│   └── (ViewModels associados a cada View)
└── Utils/
    └── Validator.swift        # Validação de inputs
```

## 🚀 Como Rodar

1. Clone o repositório.
2. Abra o projeto `Ciganus.xcodeproj` no Xcode 15+.
3. Certifique-se de ter o arquivo `GoogleService-Info.plist` configurado na raiz do projeto (necessário para o Firebase).
4. Aguarde o download dos pacotes SPM.
5. Execute o app no simulador ou dispositivo real.

## 🧪 Testes

Para rodar os testes unitários:
1. Pressione `Cmd + U` no Xcode.
2. Verifique os resultados na aba de Testes.

---

Desenvolvido com foco em qualidade e boas práticas de engenharia de software iOS.
