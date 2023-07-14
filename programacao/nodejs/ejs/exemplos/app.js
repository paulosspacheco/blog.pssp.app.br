import express from 'express';

const app = express();
const port = 3000;

app.set('view engine', 'ejs');
app.set('views', './views');

var pessoas = [
    {
        'nome': 'Paulo',
        'idade': 12
    },
    {
        'nome': 'João',
        'idade': 15,
    },
    {
        'nome': 'Marina',
        'idade': 25,
    },
]

app.get('/', (req, res) => {
    res.render('home.ejs', {pessoas: pessoas});
});

app.listen(port,() => {
    console.log(`Servidor rodando na porta ${port}`);
});