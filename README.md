# D4CFF - Exemplo de Consumo da API CClassTrib (Conformidade Fácil)

Este projeto demonstra como consumir a API de CClassTrib do projeto **Conformidade Fácil** da Reforma Tributária utilizando Delphi.

## 📋 Sobre o Projeto

O D4CFF é um exemplo prático de integração com a API de classificação tributária da Reforma Tributária, implementado em Delphi utilizando certificado digital A1 para autenticação.

Este projeto é fornecido pelo **SACFiscal**, para auxiliar na adequação à Reforma Tributária brasileira.

🌐 **Site oficial:** [https://www.sacfiscal.com.br](https://www.sacfiscal.com.br)

## 🚀 Tecnologias Utilizadas

- **Delphi** - Linguagem de programação principal
- **Indy (Internet Direct)** - Componentes para comunicação HTTP/HTTPS
- **Certificado Digital A1** - Autenticação na API

## ⚙️ Requisitos

### DLLs Necessárias

Para o correto funcionamento da aplicação, é necessário ter as seguintes DLLs na pasta do executável:

- `libeay32.dll` - Biblioteca OpenSSL para criptografia
- `ssleay32.dll` - Biblioteca OpenSSL para SSL/TLS

> **Nota:** As DLLs devem ser compatíveis com a versão do Windows (32 ou 64 bits) e do executável compilado.

### Certificado Digital

- Certificado Digital A1 válido (formato .pfx)
- Senha do certificado

## 📦 Instalação

1. Clone o repositório:
```bash
git clone https://github.com/seu-usuario/D4CFF.git
```

2. Abra o projeto no Delphi

3. Copie as DLLs `libeay32.dll` e `ssleay32.dll` para a pasta do executável compilado

4. Configure o certificado digital A1 na aplicação

## 🎯 Funcionalidades

- Consumo da API CClassTrib do Conformidade Fácil
- Autenticação via certificado digital A1
- Comunicação segura HTTPS
- Exemplos de requisições à API

## 📚 API Conformidade Fácil - Reforma Tributária

Este projeto consome a API de classificação tributária relacionada à Reforma Tributária brasileira, permitindo consultas e operações conforme as novas regras fiscais.

Para mais informações sobre o SACFiscal e a API Conformidade Fácil, acesse: [https://www.sacfiscal.com.br](https://www.sacfiscal.com.br)

## 🤝 Contribuindo

Contribuições são bem-vindas! Sinta-se à vontade para abrir issues ou enviar pull requests.

## 📄 Licença

Este projeto é um exemplo educacional para demonstração de consumo de API.

## ⚠️ Avisos Importantes

- Mantenha seu certificado digital em local seguro
- Não compartilhe a senha do certificado
- Verifique a validade do certificado antes de utilizar
- As DLLs OpenSSL devem corresponder à arquitetura do executável (x86/x64)

## 📞 Suporte

Para mais informações sobre a API Conformidade Fácil, consulte:
- 🌐 Site oficial: [https://www.sacfiscal.com.br](https://www.sacfiscal.com.br)
- 📖 Documentação oficial do projeto SACFiscal

---

**Desenvolvido com base no SACFiscal - Conformidade Fácil**
