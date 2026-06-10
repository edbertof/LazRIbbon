# Roadmap após LazRibbon 0.2.0

## 0.2.x — Consolidação do Ribbon

Objetivo: deixar o pacote previsível para uso em aplicações reais.

Prioridades:

1. revisar vínculos Action / LinkedItem em todos os componentes;
2. melhorar demos em `.lfm`;
3. reduzir resíduos conceituais herdados do LazToolbar;
4. documentar uso mínimo;
5. corrigir regressões sem adicionar grandes recursos visuais.

## 0.3.x — TLazRibbonForm

Objetivo: criar formulário estilo Office/DevExpress.

Escopo inicial recomendado: Windows-first.

Tarefas:

1. criar `TLazRibbonForm`;
2. integrar título da janela ao Ribbon;
3. prever botões minimizar/maximizar/fechar;
4. respeitar DPI;
5. manter alternativa para uso em `TForm` comum.

## 0.4.x — SkinEditor e skins externos

Objetivo: tirar skins do código-fonte e permitir edição externa.

Tarefas:

1. formato `.lazskin` ou `.lrskin`;
2. editor visual de skins;
3. preview com `TLazRibbon`;
4. ícones de skins;
5. importação/exportação.

## 0.5.x — Design-time avançado

Objetivo: melhorar a experiência no Lazarus IDE.

Tarefas:

1. editores próprios para coleções;
2. comandos rápidos de adicionar página/comando/separador;
3. melhor integração com `TActionList`;
4. validações no Object Inspector;
5. demos finais.

## 1.0

Critérios mínimos:

- instalação limpa com LazToolbar coexistindo;
- demos principais funcionando;
- documentação básica;
- sem erros conhecidos de fechamento;
- sem regressões graves no BackStage, QAT, SkinManager e ApplicationButton.
