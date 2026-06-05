var express = require("express");
var router = express.Router();

var leituraController = require("../controllers/leituraController");


router.get("/ultimas/:idCanavial", function (req, res) {
    leituraController.buscarUltimasLeituras(req, res);
});


router.get("/tempo-real/:idCanavial", function (req, res) {
    leituraController.buscarLeituraEmTempoReal(req, res);
});

module.exports = router;
