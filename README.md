

# Configuração das máquinas do GAPH

> Scripts atualizados para Ubuntu 16.04, contudo, é bem provavel que ele funcione em versões mais atuais. **Infraestrutura do GAPH deve migrar para o Ubuntu 16.04.x** que pode ser baixado [aqui](http://www.ubuntu.com/download/desktop). Instruções de como criar uma pendrive *bootável* podem ser encontradas [aqui](http://www.ubuntu.com/download/desktop/create-a-usb-stick-on-ubuntu)


## Instalação do Ubuntu em máquina do laboratório GAPH

Siga as opções padrão de instalação do Ubuntu.

Selecione **Inglês** como idioma.

Particione os discos (se ouver mais de 1) conforme o esquema:

![Partition scheme](https://rawgit.com/leoheck/gaph-os-scripts/master/doc/figs/partitions.svg)

*Obs.: Se tiverem mais discos, crie um ponto de montagem de 1 TB para o /sim*

Por fim, coloque suas credenciais de usuário. Lembre-se de criar o usuário com um nome diferente do seu usuário de rede.

Pergunte o **hostname** para algum dos administradores (professores e doutorandos)

_Não criptografe o disco! Isso só dificulta operações futuras._


## Configurações específicas do GAPH

Para configurar a máquina execute os seguintes comandos no terminal:

```
sh -c sudo "$(curl -fsSL https://github.com/leoheck/gaph-os-scripts/tools/configure.sh)"
```

Selecione a opção mais conveniente:

1. Configuração completa de máquina GAPH
2. Somente ferramentas (para uso pessoal)


Pronto, agora é só esperar e reiniciar :)