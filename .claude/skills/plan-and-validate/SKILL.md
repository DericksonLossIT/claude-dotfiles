---
name: plan-and-validate
description: >-
  Use SEMPRE que o usuário apresentar uma ideia, proposta ou mudança que ainda
  não foi validada — de qualquer domínio (negócio, produto, processo, software,
  conteúdo). Gatilhos típicos: "pensei em...", "tive uma ideia", "o que acha?",
  "faz sentido?", "vale a pena?", "como decido se...", "não sei se vai
  funcionar", "quero tirar do papel", ou simplesmente descrever um problema e
  cogitar uma solução sem certeza. Mesmo pedidos casuais de opinião sobre uma
  ideia nova são validação disfarçada — rode este skill. Conduz a ideia por
  enquadramento do problema, levantamento de premissas arriscadas, desenho do
  teste mais barato, e decisão go/no-go com critério de morte. Produz artefatos
  em disco que alimentam a execução depois. É a porta de entrada: rode ANTES de
  construir.
---

# plan-and-validate

Um harness fino que separa **pensar** de **fazer**. Ele é genérico de propósito
porque o *processo de validar uma ideia* é estável entre domínios; ele para
antes da execução porque a *execução* é específica do domínio e não deve ser
genérica. O objetivo é gastar pouco para descobrir cedo se a ideia se sustenta,
e sair com um plano e critérios claros — ou com a decisão consciente de não
seguir.

## Princípios

- **O barato vem primeiro.** A meta de cada estágio é falsificar a ideia o mais
  cedo e mais barato possível, não confirmá-la. Procurar provas contrárias é o
  trabalho.
- **Estado vive em arquivos, não na conversa.** Cada estágio produz um artefato
  em disco. Isso torna a decisão auditável e é exatamente o input que um loop de
  execução (estilo "Ralph") precisa depois.
- **Este harness orquestra, não reinventa.** Onde já existe uma skill melhor
  para um estágio, delegue a ela. Veja o mapa em cada estágio.
- **Todo estágio tem um portão.** Se um estágio derruba a ideia, pare e diga
  isso — não empurre para o próximo por inércia.

## Onde ficam os artefatos

Crie uma pasta por ideia, com um slug curto:

```
validation/<slug-da-ideia>/
  00-frame.md       # enquadramento
  01-assumptions.md # premissas ranqueadas
  02-cheapest-test.md
  03-decision.md    # go/no-go + critério de morte
  plan.md           # plano / handoff para execução (só se for "go")
```

Em projeto de software, `validation/` na raiz do repo. Fora de software, uma
pasta de notas do usuário (pergunte onde, ou use o cwd). Sempre confirme o
caminho antes de escrever o primeiro arquivo.

Cada artefato tem um molde preenchível em `templates/` (`00-frame.md`,
`01-assumptions.md`, `02-cheapest-test.md`, `03-decision.md`, `plan.md`). Comece
copiando o template do estágio para a pasta da ideia e preencha-o — os campos e o
portão já vêm prontos. Não reinvente a estrutura a cada vez.

## Os quatro estágios

Conduza um estágio por vez. Ao fim de cada um, escreva o artefato e mostre o
portão (seguir / parar / revisar) antes de avançar.

### 1 — Enquadrar  →  `00-frame.md`

Estabeleça o terreno antes de discutir solução. Responda, em uma página:

- **Problema:** qual dor/oportunidade concreta? (não a solução — a dor)
- **Quem:** para quem isso importa, e como eles resolvem isso hoje?
- **Sucesso:** como seria o mundo se desse certo? Qual o sinal observável?
- **Restrições:** tempo, dinheiro, habilidades, contexto que limitam.

Se o domínio tem vocabulário próprio que precisa ser fixado para evitar
ambiguidade, delegue a `domain-modeling` antes de fechar este artefato.

Portão: o problema é real e vale a pena? Se "é solução em busca de problema",
pare aqui.

### 2 — Premissas  →  `01-assumptions.md`

Liste tudo que precisa ser verdade para a ideia funcionar. Depois ranqueie por
**(impacto se falso) × (incerteza)**. A do topo é a **premissa mais arriscada** —
é ela que o próximo estágio vai testar.

Este é o estágio onde o auto-engano mora. Delegue a `grilling` para interrogar
o plano sem dó e expor premissas que você está tratando como fato. Não saia
daqui com uma lista confortável.

Portão: existe pelo menos uma premissa que, se falsa, mata a ideia — e você sabe
qual é?

### 3 — Teste mais barato  →  `02-cheapest-test.md`

Desenhe o experimento de menor custo que poderia **falsificar a premissa mais
arriscada**. Não é um protótipo bonito — é a evidência mais barata possível.
Defina, antes de rodar: o que você vai fazer, e qual resultado significaria
"premissa falsa".

- Não-software: conversa com 5 usuários reais, uma landing page de espera, uma
  planilha modelando os números, uma simulação manual do processo.
- Software: o "andar de esqueleto" mínimo, ou — se o risco está na *forma* da
  interface/API — delegue a `design-an-interface` para esboçar a interface e
  ver se ela se sustenta antes de implementar.

Rode o teste (ou registre que precisa rodar) e anote o resultado no artefato.

Portão: a evidência sustenta a premissa? Se não, volte ao estágio 1 com o que
aprendeu, ou mate a ideia.

### 4 — Go / no-go  →  `03-decision.md`

Decida com base nos três artefatos anteriores. Registre:

- **Decisão:** go / no-go / pivô (com a mudança).
- **Critério de morte:** o que você vai observar durante a execução que, se
  acontecer, faz você parar. Definir isto agora — a frio — é o que separa
  validação de torcida. É o estágio que quase todo mundo pula.
- **Próximos passos** (só se "go"): aponte para `plan.md`.

Se for "go", produza `plan.md`. Para software, delegue a `request-refactor-plan`
ou a `start-feature-branch` para quebrar em passos executáveis com critérios de
aceite. Para não-software, um plano de passos com marcos e critérios de aceite
verificáveis.

## Handoff

`plan.md` + os critérios de aceite são o contrato com a execução. A execução é
deliberadamente *fora* do escopo deste harness: ela é específica do domínio e
pode rodar num loop próprio que lê o plano, faz uma tarefa por vez, verifica
contra os critérios, e atualiza o estado. Este harness entrega o que esse loop
precisa para começar — e o critério de morte que o faz parar.

## Modo de uso flexível

Nem toda ideia precisa dos quatro estágios completos. Para algo pequeno e
reversível, comprima: enquadre em um parágrafo, identifique a premissa mais
arriscada, e decida. O valor está na *ordem* (problema antes de solução, risco
antes de plano, critério de morte antes de começar), não no formalismo. Não
transforme o harness em burocracia que custa mais que a ideia que valida.
