var empresaModel = require("../models/empresaModel");

function gerarCodigoAcesso() {
  const caracteres = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
  let codigo = '';
  for (let i = 0; i < 6; i++) {
    const indiceAleatorio = Math.floor(Math.random() * caracteres.length);
    codigo += caracteres.charAt(indiceAleatorio);
  }
  return codigo;
}

function buscarPorCnpj(req, res) {
  var cnpj = req.query.cnpj;

  empresaModel.buscarPorCnpj(cnpj).then((resultado) => {
    res.status(200).json(resultado);
  });
}

function listar(req, res) {
  empresaModel.listar().then((resultado) => {
    res.status(200).json(resultado);
  });
}

function buscarPorId(req, res) {
  var id = req.params.id;

  empresaModel.buscarPorId(id).then((resultado) => {
    res.status(200).json(resultado);
  });
}

var empresaModel = require("../models/empresaModel");

function autenticar(req, res) {
  var cnpj = req.body.cnpjServer;
  var codigo = req.body.codigoServer;
  var senha = req.body.senhaServer;

  if (cnpj == undefined) {
    res.status(400).send("Seu CNPJ está undefined!");
  } else if (codigo == undefined) {
    res.status(400).send("Seu código de acesso está undefined!");
  } else if (senha == undefined) {
    res.status(400).send("Sua senha está indefinida!");
  } else {
    empresaModel.autenticar(cnpj, codigo, senha)
      .then(function (resultadoAutenticar) {
        console.log(`\nResultados encontrados: ${resultadoAutenticar.length}`);

        if (resultadoAutenticar.length == 1) {
          res.json({
            id: resultadoAutenticar[0].id,
            cnpj: resultadoAutenticar[0].cnpj,
            nome: resultadoAutenticar[0].nome_fantasia
          });
        } else if (resultadoAutenticar.length == 0) {
          res.status(403).send("CNPJ, Código e/ou Senha inválido(s)");
        } else {
          res.status(403).send("Mais de uma empresa com os mesmos dados de acesso!");
        }
      })
      .catch(function (erro) {
        console.log(erro);
        res.status(500).json(erro.sqlMessage);
      });
  }
}

function cadastrar(req, res) {
  var dados = req.body
  var cnpj = dados.empresa.cnpj;
  var razaoSocial = dados.empresa.razaoSocial;
  var nomeFantasia = dados.empresa.nomeFantasia;
  var senha = dados.empresa.senha;
  var logradouro = dados.empresa.logradouro;
  var numero = dados.empresa.numero;
  var complemento = dados.empresa.complemento;
  var cep = dados.empresa.cep;
  var estado = dados.empresa.estado;
  var cidade = dados.empresa.cidade;
  var plano = dados.empresa.plano;
  var nomeCanavial = dados.empresa.nomeCanavial;
  var coordenadasCanavial = dados.empresa.coordenadasCanavial;
  var nome = dados.empresa.representante.nome;
  var email = dados.empresa.representante.email;
  var dataNascimento = dados.empresa.representante.dataNascimento;
  var senhaRepresentante = dados.empresa.representante.senha;

  if (cnpj == undefined) {
    res.status(400).send("Seu CNPJ está undefined!");
  } else if (razaoSocial == undefined) {
    res.status(400).send("Sua Razão Social está undefined!");
  } else if (nomeFantasia == undefined) {
    res.status(400).send("Seu Nome Fantasia está undefined!");
  } else if (senha == undefined) {
    res.status(400).send("Sua Senha está undefined!");
  } else if (logradouro == undefined) {
    res.status(400).send("Seu Logradouro está undefined!");
  } else if (numero == undefined) {
    res.status(400).send("Seu Número está undefined!");
  } else if (complemento == undefined) {
    res.status(400).send("Seu Complemento está undefined!");
  } else if (cep == undefined) {
    res.status(400).send("Seu CEP está undefined!");
  } else if (estado == undefined) {
    res.status(400).send("Seu Estado está undefined!");
  } else if (cidade == undefined) {
    res.status(400).send("Sua Cidade está undefined!");
  } else if (plano == undefined) {
    res.status(400).send("Seu Plano está undefined!");
  } else if (nomeCanavial == undefined) {
    res.status(400).send("Sua Canavial está undefined!");
  } else if (coordenadasCanavial == undefined) {
    res.status(400).send("A coordenada do Canavial está undefined!");
  } else if (nome == undefined) {
    res.status(400).send("Seu Nome está undefined!");
  } else if (email == undefined) {
    res.status(400).send("Seu Email está undefined!");
  } else if (dataNascimento == undefined) {
    res.status(400).send("Sua Data de Nascimento está undefined!");
  } else if (senhaRepresentante == undefined) {
    res.status(400).send("Sua Senha está undefined!");
  } else {
    empresaModel.buscarPorCnpj(cnpj).then((resultado) => {
      if (resultado.length > 0) {
        res
          .status(401)
          .json({ mensagem: `a empresa com o cnpj ${cnpj} já existe` });
      } else {
        var codigoAtivacao = gerarCodigoAcesso();

        empresaModel.cadastrar(razaoSocial, nomeFantasia, cnpj, senha, logradouro, numero, complemento, cep, estado, cidade, plano, nomeCanavial, coordenadasCanavial,
          nome, email, dataNascimento, senhaRepresentante, codigoAtivacao).then((resultado) => {
          res.status(201).json({
            resultado: resultado,
            codigoAtivacao: codigoAtivacao
          });
        }).catch((erro) => {
          console.log(erro);
          res.status(500).json(erro);
        });
      }
    });
  }
}

module.exports = {
  buscarPorCnpj,
  buscarPorId,
  autenticar,
  cadastrar,
  listar,
};
