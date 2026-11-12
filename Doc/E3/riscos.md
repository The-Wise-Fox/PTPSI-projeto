1. Recursos e Tecnologias (Atualizado)
O projeto assenta numa stack tecnológica web moderna e amplamente documentada, garantindo a viabilidade da implementação (E5 e E6):
Frontend: HTML5, CSS3 e JavaScript. Focados na criação de interfaces responsivas e validação de dados no lado do cliente.
Backend (Servidor): Node.js com JavaScript. Escolhido pela eficiência na manipulação de I/O assíncrono e facilidade de integração com o frontend.
Base de Dados: MySQL. Sistema relacional robusto, escolhido para garantir a integridade dos dados (conforme justificado no justificacao.md).
Infraestrutura e Ferramentas de Apoio: XAMPP/Docker para ambiente local (MySQL), Git/GitHub para versionamento do código, draw.io (para diagramas) e MySQL Workbench.


2. Análise de Riscos

Risco Identificado	                             Probabilidade	  Impacto	          Estratégia de Mitigação / Resolução
Newsletter sem infraestrutura definida (E1/E2)	     Alta	       Médio	           Mitigação: O envio de emails (avisos/confirmações) exige um serviço SMTP. Como o Node.js será o backend, iremos integrar uma biblioteca como o Nodemailer e avaliar serviços gratuitos (ex: Mailtrap para testes, SendGrid ou Gmail SMTP para produção) para não bloquear o desenvolvimento.
Preço por serviço ainda ambíguo (E1/E2)	             Média	       Alto	               Mitigação: No modelo de base de dados atual, o preço está fixo na tabela servico (coluna valor). Se o preço variar consoante o tipo de local ou contrato, a base de dados terá de ser alterada. Ação imediata: Definir as regras de negócio do cálculo do preço antes de iniciar o E5 para evitar refazer o modelo de dados e o código do backend.
Segurança de Dados (Passwords)	                     Alta	       Alto	               Mitigação: O script.sql atual contém passwords em texto limpo (apenas para testes). A equipa tem de garantir que, no backend (E5), é aplicada uma função de hash (ex: bcrypt) antes de inserir ou comparar dados na tabela utilizador.
