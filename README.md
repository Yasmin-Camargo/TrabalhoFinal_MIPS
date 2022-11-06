# TrabalhoFinal_MIPS
![image](https://user-images.githubusercontent.com/88253809/200189257-90353981-62f5-4ffe-93dc-459470938c5c.png)

Jogo da forca desenvolvido em Assembly no MIPS como trabalho avaliativo da disciplina de Arquitetura e Organização de Computadores I (AOC), do curso de Ciência da Computação na UFPel


## Descrição
O grupo desenvolveu um jogo da forca para jogar contra uma pessoa. Dessa forma, quando o usuário escolher a opção de jogar será requisitada a quantidade de letras da palavra, a dica e também a palavra que será a forca. Depois de inseridas estas informações a dinâmica do jogo começa, no qual outro jogador deve inserir letras e tentar adivinhar qual é a palavra, dentro de um número limitado de tentativas.

https://user-images.githubusercontent.com/88253809/200192878-5f99b586-7ee8-4d84-b7d4-b6f3c5f48fd6.mp4

## Funcionalidades do jogo
### Menu para navegar entre as opções do jogo

![image](https://user-images.githubusercontent.com/88253809/200194772-03acc172-1818-4c8b-8bda-bbcff76ac2e3.png)

### Utilização de string e vetores para armazenar informações
- Espaços reservados na memória para armazenar a palavra do jogo da forca e uma versão da palavra com underlines (que será preenchida durante o jogo)
- Espaços reservados na memória para armazenar a dica do jogo, a letra atual digitada pelo usuário e o histórico de letras
- Também são armazenados na memória Strings que vão servir para interagir com o usuário

![image](https://user-images.githubusercontent.com/88253809/200194796-21daa361-a26a-428e-a028-5032a783bc65.png)


### Chamadas de sistema para realizar a interação com o usuário

- Entrada: para digitar uma opção do menu, digitar a quantidade de letras da palavra, digitar a palavra e a sua respectiva dica
![image](https://user-images.githubusercontent.com/88253809/200194852-777d6324-4018-4ad9-87ed-9928d81b859a.png)

- Saída: a palavra (que vai se revelando conforme as letras vão sendo acertadas), avisos de ganhou e perdeu e mensagens de forma geral 
 ![image](https://user-images.githubusercontent.com/88253809/200195031-699898d9-d7a8-49f4-a5a7-f811bb231248.png)

### Sub Rotinas para as principais funcionalidades do jogo: 
- leitura do tamanho da palavra
- leitura da palavra 
- leitura da dica
- inicializar palavra com underlines
- leitura do caractere digitado
- verificar se a letra já foi digitada

### Outras funcionalidades desenvolvidas ao longo do código:
- Verificar se o caractere digitado está presente em alguma parte da palavra
- Verificar se a palavra da forca já foi totalmente preenchida (Isso foi feito através de um contador de palavras certas, caso esse contador atingisse o tamanho da palavra total era o sinal que a pessoa tinha adivinhado toda palavra)
- Controlar a quantidade de letras erradas que foram chutadas pelo usuário (Não deixar passar o limite definido, caso aconteça o jogador perde o jogo)
- Foi necessário verificar as letras digitadas pelo usuário que caso a pessoa digitasse mais de uma vez a mesma letra não ocorresse uma contabilização de erro ou acerto que não deveria
- Na parte de inicializar com underlines a palavra, caso fosse encontrado um espaço na palavra digitada era colocado um hífen no que era exibido na tela (para que assim a pessoa pudesse identificar que a palavra tinha espaço)

### Tratamentos de erros:
- Não é permitido inserir caracteres quando é requisitado um número inteiro
- No menu só aceita os números dentro do intervalo definido
- Na leitura de strings não aceita palavras maiores do que foi estabelecido
- Não são aceitos campos em brancos
- Opção voltar sempre redireciona para o menu
- Não são aceitas letras repetidas

### Sons
- Som para indicar algo inválido
- Som para vitória no jogo
- Som para derrota no jogo

### Distribuições dos registradores no código:
![image](https://user-images.githubusercontent.com/88253809/200195051-961e9555-6759-400e-aae3-eca72d1ca593.png)




