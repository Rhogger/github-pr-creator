---
name: github-pr-creator
description: Cria Pull Requests no GitHub seguindo um workflow de 4 etapas (Contexto, Mineração, Análise e Publicação). Extrai diffs, resume alterações e usa a CLI gh para abrir o PR.
---

# GitHub PR Creator

Esta skill automatiza a criação de Pull Requests de alta qualidade, analisando semântica de commits e código para gerar descrições precisas.

## Configuração (preencher antes de usar)

Substitua os placeholders abaixo pelos seus dados para evitar perguntas repetidas e chamadas desnecessárias ao git.

- **Autor (assignee)**: `<SEU_USERNAME_GITHUB>`
- **Revisores**: `<REVISOR_1_USERNAME>, <REVISOR_2_USERNAME>` (ex.: `alison, vanessa`)
- **Branches bloqueadas**: `main`, `master`, `dev`, `hml`
- **Branch base padrão**: `<BRANCH_BASE>` (ex.: `main`)

## Workflow de Automação

### 1. Orquestração de Contexto (Context Manager)
Antes de qualquer análise, identifique os metadados:
- **Usuário**: Obtenha o autor atual via `git config user.name`.
- **Branch**: Se não informada, use `git branch --show-current`.
- **Bloqueio**: Se a branch for `main`, `master`, `dev` ou `hml`, pare e informe que PRs não devem ser gerados diretamente nestas branches.
- **Commits**: Obtenha as hashes exclusivas da branch atual em relação à base (ex: `main`).
- **Revisor**: Se não informado pelo usuário, você **DEVE** perguntar quem será o revisor.

### 2. Mineração de Dados (Git Ops Specialist)
Para cada hash identificada:
- Extraia a mensagem do commit (`git show -s --format=%B`).
- Obtenha o diff das alterações.
- Identifique arquivos modificados, focando no que mudou (ignore binários ou arquivos excessivamente grandes, trazendo apenas o diff nesses casos).

### 3. Análise e Decisão (Software Architect)
Digerir os dados para definir a estratégia:
- **Tipo de PR**: Decida entre `FEATURE` (lógica nova), `BUGFIX` (correções) ou `REFACTOR` (limpeza/organização).
- **Sumarização**: Cruze mensagens de commit com o código para entender o "Porquê". Gere um resumo técnico em tópicos.
- **Testes**: Infira passos de teste lógicos baseados na alteração realizada.

### 4. Publicação (Technical Writer)
Gere o conteúdo final e execute:
- **Template**: Busque o template correspondente em `references/` (`feature_template.md`, `bugfix_template.md` ou `refactor_template.md`), relativo à raiz desta skill. Use-o como base para preencher as informações coletadas.
- **CLI**: Use `gh pr create` para abrir o PR.
- **RESTRIÇÃO**: NÃO faça `git commit`, `git push` ou crie arquivos de mensagem físicos (como PR_MESSAGE.md), a menos que solicitado. O PR deve ser aberto diretamente via CLI.

## Comandos Úteis
- Verificação de branch: `git branch --show-current`
- Log de commits: `git log origin/main..HEAD --format="%H"`
- Criar PR: `gh pr create --title "[TIPO] Título" --body "Conteúdo" --reviewer "username"`
