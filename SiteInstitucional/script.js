// Declaração de variáveis Globais

let vt_email = [];
let vt_senha = [];
let vt_CNPJ = [];
let vt_razaoSocial = [];

function Entrar(){

        let cliente = ipt_email_user.value
        let senhaCliente = ipt_senha_user.value

        let cliente1 = `simpaticoCliente@gmail.com`
        let senha1 = `simpaticaSenha123`;

        if(cliente != cliente1 || senhaCliente != senha1)
        {
            alert(`Usuário não cadastrado!`)
        }
        else 
        {
            alert(`Conectado! Bem vindo '${cliente}'!`)
        }

        ipt_email_user.value = " ";
        ipt_senha_user.value = "";
    } 

function Cadastrar(){
    let RazaoSocial = ipt_razao_social.value.trim();
    vt_razaoSocial.push(RazaoSocial);

    let email = ipt_email_user.value.trim();
    vt_email.push(email);

    let CNPJ = ipt_CNPJ.value.trim();
    vt_CNPJ.push(CNPJ);

    let senha = ipt_senha_user.value.trim();
    vt_senha.push(senha);

    let confirmacaoSenha = ipt_confirma_senha.value.trim();

    if(!email.includes('@') || !email.includes('.')){
        alert("/ Email deve conter @ e um domínio! /");
    }
    else if(CNPJ.length != 14) // CNPJ tem que ter exatos 14 caracteres! (Sem pontuações)
    {
        alert("/ O CNPJ deve ter 14 Caracteres! /")
    }
    else if(senha.length < 8) // Senha deve ter no minimo 8 caracteres!
    {
        alert("/ Senha deve ter no minimo 8 caracteres! /")
    }
    else if (confirmacaoSenha != senha)
    {
        alert("As senhas não estão iguais!");
    }
    else
    {   
        alert("Usuário Criado!");
    }

    ipt_senha_user.value = "";
    ipt_confirma_senha.value = "";
    ipt_razao_social.value = "";
    ipt_email_user.value = "";
    ipt_CNPJ.value = "";
    console.log(vt_CNPJ);
    console.log(email);
    console.log(senha);
    console.log(RazaoSocial);
    
}