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
  var cnpj = req.body.cnpj;
  var razaoSocial = req.body.razaoSocial;
  var nomeFantasia = req.body.nomeFantasia;
  var senha = req.body.senha;

  if (cnpj == undefined) {
    res.status(400).send("Seu CNPJ está undefined!");
  } else if (razaoSocial == undefined) {
    res.status(400).send("Sua Razão Social está undefined!");
  } else if (nomeFantasia == undefined) {
    res.status(400).send("Seu Nome Fantasia está undefined!");
  } else if (senha == undefined) {
    res.status(400).send("Sua Senha está undefined!");
  } else {
    empresaModel.buscarPorCnpj(cnpj).then((resultado) => {
      if (resultado.length > 0) {
        res
          .status(401)
          .json({ mensagem: `a empresa com o cnpj ${cnpj} já existe` });
      } else {
        var codigoAtivacao = gerarCodigoAcesso();

        empresaModel.cadastrar(razaoSocial, nomeFantasia, cnpj, senha, codigoAtivacao).then((resultado) => {
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
