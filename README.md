# 🌍 Projeto de Reciclagem Inteligente com Flutter, Visão Computacional e Supabase

Bem-vindo ao repositório do **Projeto de Reciclagem Inteligente**! Este projeto foi desenvolvido para um hackathon e combina tecnologias de **Flutter** para a aplicação mobile, **Supabase** para gerenciamento de dados, e **Visão Computacional** para identificar itens recicláveis e calcular a pontuação. 

### Índice

- [Sobre o Projeto](#sobre-o-projeto)
- [Objetivo](#objetivo)
- [Funcionalidades](#funcionalidades)
- [Arquitetura do Projeto](#arquitetura-do-projeto)
- [Tecnologias Utilizadas](#tecnologias-utilizadas)
- [Instalação e Configuração](#instalação-e-configuração)
- [Banco de Dados (Supabase)](#banco-de-dados-supabase)
- [Mapeamento do Usuário e Proposta de Valor](#mapeamento-do-usuário-e-proposta-de-valor)
  - [Mapa de Empatia](#mapa-de-empatia)
  - [Jornada do Usuário](#jornada-do-usuário)
  - [Value Proposition Canvas](#value-proposition-canvas)
- [Contribuições](#contribuições)

---

## Sobre o Projeto

Este projeto visa incentivar a reciclagem, facilitando o processo de coleta e pontuação de materiais recicláveis. Através do aplicativo mobile, os usuários podem cadastrar e pontuar itens recicláveis, utilizando **visão computacional** para detectar e categorizar os itens. Os dados são armazenados e gerenciados com o **Supabase**, permitindo uma gestão eficiente e escalável.

## Objetivo

O principal objetivo é **promover a conscientização ambiental** e incentivar a reciclagem através de um sistema de pontos. Quanto mais o usuário recicla, mais pontos ele acumula, podendo trocar por recompensas ou benefícios.

## Funcionalidades

- **Cadastro de Usuários e Login Seguro**
- **Identificação de Itens Recicláveis com Visão Computacional**
- **Pontuação de Itens** com base no tipo de material reciclado
- **Gestão de Recompensas**
- **Relatórios e Estatísticas de Reciclagem**

---

## Arquitetura do Projeto

O projeto é dividido em três principais componentes:

1. **Aplicação Mobile (Flutter)**: Interface amigável e intuitiva para os usuários realizarem o cadastro e acompanhamento de itens recicláveis.
2. **Banco de Dados (Supabase)**: Gestão de usuários, itens e pontuações em uma estrutura escalável.
3. **Visão Computacional**: Identificação e classificação automática de itens recicláveis usando algoritmos de Machine Learning.

---

## Tecnologias Utilizadas

- **Flutter**: Framework para desenvolvimento da aplicação mobile.
- **Supabase**: Banco de dados e autenticação.
- **Python** e **OpenCV**: Utilizados para a visão computacional e identificação de objetos recicláveis.
- **Docker**: Para containerização e fácil implantação dos módulos de visão computacional.

---

## Instalação e Configuração

### Pré-requisitos

- [Flutter SDK](https://flutter.dev/docs/get-started/install)
- Conta no [Supabase](https://supabase.io/)

### Passo a Passo

1. **Clone o repositório**:
   ```bash
   git clone https://github.com/notsogreatdavi/hackathon-bb.git
   cd hackathon-bb
