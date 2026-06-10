---
name: github-pr-creator
description: Cria Pull Requests no GitHub seguindo um workflow de 4 etapas (Contexto, Mineração, Análise e Publicação). Extrai diffs, resume alterações e usa a CLI gh para abrir o PR.
---

# GitHub Pull Request Creator

Esta skill automatiza a criação de Pull Requests (PRs) de alta qualidade no GitHub, analisando semântica de commits e código para gerar descrições precisas.

## 🚀 Configuração Rápida (Primeiro uso — executar apenas uma vez)

> **Importante**: Esta skill **NÃO** configura nem valida o `gh`. Ela apenas cria o PR. A configuração é responsabilidade do usuário e deve ser feita **uma única vez**, no primeiro uso, executando o script `scripts/gh_config.sh`.

Se ainda não configurou, siga estes passos:

### 1. Autenticação via CLI

Recomendamos usar o comando nativo:
```bash
gh auth login
```
Ou, se preferir via script configurável:
1. Edite o arquivo: `scripts/gh_config.sh`
2. Execute no terminal:
   ```bash
   ./scripts/gh_config.sh
   ```

---

## ⚙️ Configuração da Skill (Metadados)

Substitua os placeholders abaixo no arquivo `SKILL.md` da sua instalação local para evitar perguntas repetidas:

- **Repositório**: `<OWNER>/<REPO>` (ex.: `google/gemini-cli`)
- **Autores (assignees)**: `<USERNAME_1_GITHUB>, <USERNAME_2_GITHUB>` (ex.: `alison, vanessa`)
- **Revisores (reviewers)**: `<REVISOR_1_USERNAME>, <REVISOR_2_USERNAME>` (ex.: `alison, vanessa`)
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

- **Tipo de PR**: Decida entre `FEATURE`, `BUGFIX`, `REFACTOR`, `HOTFIX`, `TESTS`, `SECURITY`, `BUILD`, `CHORE`, `DOCS`, `PERF` ou `WIP`.
- **Sumarização**: Cruze mensagens de commit com o código para entender o "Porquê". Gere um resumo técnico em tópicos.
- **Título**: O título do PR **DEVE** seguir rigorosamente o padrão: `[NOME-DA-BRANCH] TIPO: Impacto principal`.
- **Testes**: Infira passos de teste lógicos baseados na alteração realizada.

### 4. Publicação (Technical Writer)

Gere o conteúdo final e execute:

- **Template**: Busque o template correspondente em `references/` relativo à raiz desta skill.
- **Detecção de host (para GHE)**: Se estiver em um GitHub Enterprise, o `gh` precisa saber o host. Extraia do remote:
  ```bash
  GH_HOST_DETECTED=$(git remote get-url origin | sed -E 's#^https?://([^/:]+).*#\1#')
  ```
- **CLI**: Use `gh pr create` para abrir o PR. Assuma que o `gh` já está instalado e autenticado — **não execute** comandos de validação (`gh auth status`, `gh --version`, `which gh`, etc.) antes de criar o PR.
- **Repositório**: Se o metadado **Repositório** estiver preenchido, utilize-o obrigatoriamente com a flag `-R <OWNER/REPO>` no comando de criação.
- **Tratamento de falha**:
  - **404 / Repository not found** → verifique se o `-R` corresponde ao dono/repo correto.
  - **401 Unauthorized / Token expired** → **PARE** e oriente o usuário a executar `scripts/gh_config.sh` ou `gh auth login`.
- **RESTRIÇÃO**: NÃO faça `git commit`, `git push` ou crie arquivos de mensagem físicos. O PR deve ser aberto diretamente via CLI.

## Comandos Úteis

- Verificação de branch: `git branch --show-current`
- Log de commits: `git log origin/main..HEAD --format="%H"`
- Criar PR (com detecção de host para GHE):
  ```bash
  GH_HOST=$(git remote get-url origin | sed -E 's#^https?://([^/:]+).*#\1#') \
  gh pr create -R "owner/repo" \
    --title "[BRANCH-NAME] TIPO: Impacto principal" \
    --body "Conteúdo" \
    --assignee "seu-user" --reviewer "username"
  ```
