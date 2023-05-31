
# **Configurando um servidor de Git no ubuntu**

O Git é um sistema de versionamento largamente utilizado por profissionais de TI, principalmente por Sysadmins, desenvolvedores e devops.

Basicamente, com ele podemos armazenar arquivos e controlar modificações. Isso nos possibilita restaurar versões prévias de tais arquivos, saber quando determinada alteração foi realizada, entre outros. O Git possibilita um mesmo repo ser utilizado por mais de uma pessoa. Por isso é utilizado em larga escala em times de desenvolvimento.

Neste artigo explicarei como configurar um git server, de forma que esse repositório do Git poderá ser utilizado em mais de um local, como abordado no exemplo anterior.


## **Instalando e configurando um Git Server:**





**Configurações feitas no desktop:**

Agora vamos configurar nosso desktop.

1 – Crie um diretório onde manterá o repo local:

```sh
    sudo mkdir ~/Git/
```

2 – Entre nesse diretório:

```sh
    sudo cd ~/Git/
```

3 – Agora clone o repositório remoto para o seu desktop com o comando:

```sh
    sudo git clone git@host-ou-ip-do-servidor:~/repos/lab.git
```

Obviamente, troque “host-ou-ip-do-servidor” pelo Host ou IP do servidor onde está o git server, mas isso você já sabe…

4 – Se tudo der certo, terá criado um diretório chamado “lab”. Entre nele.

5 – Faremos agora o primeiro commit. Primeiro, crie um arquivo em branco:

```sh
    touch la_vai_meu_teste.txt
```

6 – Adicione esse arquivo ao Git:

```sh
    git add la_vai_meu_teste.txt
```

7 – Comente esta inclusão:

```sh
    git commit -am "Meu primeiro commit uhull" la_vai_meu_teste.txt
```

8 – E por fim, suba a alteração para o git server:

```sh
    git push
```

## **Conclusão:**

???


## HISTÓRICO

