# StudioFlow 💜

**Seu momento, seu estilo.**

Aplicativo mobile para gerenciamento de agendamentos em salões de beleza e barbearias, desenvolvido como projeto acadêmico no SENAI Roberto Mange.

## Funcionalidades

- Cadastro e consulta de agendamentos.
- Seleção de serviços, profissionais, datas e horários.
- Validação dos dados dos clientes.
- Consulta de endereço pela API ViaCEP.
- Cancelamento de agendamentos com token de segurança.
- Login e área administrativa.
- Cadastro, edição e exclusão de serviços.
- Persistência local com SharedPreferences.
- Persistência externa com Supabase.

## Tecnologias

- Flutter e Dart.
- Supabase.
- SharedPreferences.
- API ViaCEP.
- HTTP e JSON.

## Métodos HTTP

| Método | Aplicação |
|---|---|
| GET | Consulta de dados e CEP. |
| POST | Cadastro de dados no Supabase. |
| PUT | Serviço REST testado com JSONPlaceholder. |
| PATCH | Edição de serviços no Supabase. |
| DELETE | Exclusão de serviços no Supabase. |

**Nota:** o PUT foi testado em uma API externa de demonstração; a edição real dos serviços utiliza PATCH.

## Como executar

1. Clone o repositório:

```bash
git clone https://github.com/gabizinhacode/Studio-Flow.git
cd Studio-Flow
```

2. Instale as dependências:

```bash
flutter pub get
```

3. Configure a URL e a chave pública do Supabase no projeto. O banco precisa ter as tabelas, políticas e funções RPC utilizadas pelo aplicativo.

4. Execute no emulador ou celular conectado:

```bash
flutter run
```

5. Analise o projeto:

```bash
flutter analyze
```

## Como gerar o APK

```bash
flutter build apk --release
```

O arquivo será gerado em `build/app/outputs/flutter-apk/app-release.apk`.

## Como instalar no Android

Transfira o arquivo `StudioFlow.apk` para o celular, abra-o pelo gerenciador de arquivos e confirme a instalação. Se solicitado, permita a instalação de aplicativos dessa origem.

Também é possível instalar pelo computador com ADB:

```bash
adb install -r StudioFlow.apk
```

O aplicativo precisa de internet para acessar o Supabase e as APIs externas.

## Identidade visual

- Roxo principal: `#7655A6`
- Fundo: `#F8F6FB`
- Destaque: `#E9DDF5`

**Slogan:** Seu momento, seu estilo.

---

Desenvolvido com 💜 e tecnologia.
