// Definição das paletas de cores
const palettes = [
    {
        name: "Windows Console (Padrão)",
        colors: [
            { name: "Preto", rgb: [0, 0, 0] },
            { name: "Azul Escuro", rgb: [0, 0, 128] },
            { name: "Verde Escuro", rgb: [0, 128, 0] },
            { name: "Ciano Escuro", rgb: [0, 128, 128] },
            { name: "Vermelho Escuro", rgb: [128, 0, 0] },
            { name: "Magenta Escuro", rgb: [128, 0, 128] },
            { name: "Amarelo Escuro", rgb: [128, 128, 0] },
            { name: "Cinza Claro", rgb: [192, 192, 192] },
            { name: "Cinza Escuro", rgb: [128, 128, 128] },
            { name: "Azul Claro", rgb: [0, 0, 255] },
            { name: "Verde Claro", rgb: [0, 255, 0] },
            { name: "Ciano Claro", rgb: [0, 255, 255] },
            { name: "Vermelho Claro", rgb: [255, 0, 0] },
            { name: "Magenta Claro", rgb: [255, 0, 255] },
            { name: "Amarelo Claro", rgb: [255, 255, 0] },
            { name: "Branco", rgb: [255, 255, 255] }
        ]
    },
    {
        name: "Tema Escuro Suave",
        colors: [
            { name: "Preto Suave", rgb: [10, 10, 10] },
            { name: "Azul Escuro Suave", rgb: [0, 0, 120] },
            { name: "Verde Escuro Suave", rgb: [0, 120, 0] },
            { name: "Ciano Escuro Suave", rgb: [0, 120, 120] },
            { name: "Vermelho Escuro Suave", rgb: [120, 0, 0] },
            { name: "Magenta Escuro Suave", rgb: [120, 0, 120] },
            { name: "Amarelo Escuro Suave", rgb: [120, 120, 0] },
            { name: "Cinza Claro Suave", rgb: [180, 180, 180] },
            { name: "Cinza Médio", rgb: [100, 100, 100] },
            { name: "Azul Claro Suave", rgb: [0, 0, 230] },
            { name: "Verde Claro Suave", rgb: [0, 230, 0] },
            { name: "Ciano Claro Suave", rgb: [0, 230, 230] },
            { name: "Vermelho Claro Suave", rgb: [230, 0, 0] },
            { name: "Magenta Claro Suave", rgb: [230, 0, 230] },
            { name: "Amarelo Claro Suave", rgb: [230, 230, 0] },
            { name: "Branco Suave", rgb: [255, 255, 255] }
        ]
    },
    {
        name: "Tema Claro Suave",
        colors: [
            { name: "Preto", rgb: [0, 0, 0] },
            { name: "Azul Claro", rgb: [0, 0, 160] },
            { name: "Verde Claro", rgb: [0, 160, 0] },
            { name: "Ciano Claro", rgb: [0, 160, 160] },
            { name: "Vermelho Claro", rgb: [160, 0, 0] },
            { name: "Magenta Claro", rgb: [160, 0, 160] },
            { name: "Amarelo Claro", rgb: [160, 160, 0] },
            { name: "Cinza Escuro", rgb: [100, 100, 100] },
            { name: "Cinza Claro", rgb: [220, 220, 220] },
            { name: "Azul Pastel", rgb: [100, 100, 255] },
            { name: "Verde Pastel", rgb: [100, 255, 100] },
            { name: "Ciano Pastel", rgb: [100, 255, 255] },
            { name: "Vermelho Pastel", rgb: [255, 100, 100] },
            { name: "Magenta Pastel", rgb: [255, 100, 255] },
            { name: "Amarelo Pastel", rgb: [255, 255, 100] },
            { name: "Branco", rgb: [255, 255, 255] }
        ]
    },
    {
        name: "Tema Azul (Frio)",
        colors: [
            { name: "Preto Azulado", rgb: [10, 10, 20] },
            { name: "Azul Profundo", rgb: [0, 0, 150] },
            { name: "Verde Azulado", rgb: [0, 100, 0] },
            { name: "Ciano Azulado", rgb: [0, 120, 150] },
            { name: "Vermelho Azulado", rgb: [100, 0, 0] },
            { name: "Magenta Azulado", rgb: [120, 0, 150] },
            { name: "Amarelo Azulado", rgb: [120, 120, 0] },
            { name: "Cinza Azulado", rgb: [180, 180, 200] },
            { name: "Cinza Médio Azulado", rgb: [80, 80, 100] },
            { name: "Azul Vibrante", rgb: [0, 0, 255] },
            { name: "Verde Água", rgb: [0, 200, 100] },
            { name: "Ciano Vibrante", rgb: [0, 200, 255] },
            { name: "Rosa", rgb: [200, 0, 100] },
            { name: "Magenta Vibrante", rgb: [200, 0, 255] },
            { name: "Amarelo Esverdeado", rgb: [200, 200, 100] },
            { name: "Branco Azulado", rgb: [230, 230, 255] }
        ]
    },
    {
        name: "Tema Verde (Natureza)",
        colors: [
            { name: "Preto Esverdeado", rgb: [10, 20, 10] },
            { name: "Azul Esverdeado", rgb: [0, 80, 100] },
            { name: "Verde Floresta", rgb: [0, 120, 0] },
            { name: "Ciano Esverdeado", rgb: [0, 120, 100] },
            { name: "Marrom", rgb: [100, 80, 0] },
            { name: "Magenta Escuro", rgb: [100, 0, 100] },
            { name: "Oliva", rgb: [100, 120, 0] },
            { name: "Cinza Esverdeado", rgb: [180, 200, 180] },
            { name: "Cinza Médio Esverdeado", rgb: [80, 100, 80] },
            { name: "Azul Claro", rgb: [0, 100, 200] },
            { name: "Verde Limão", rgb: [0, 255, 0] },
            { name: "Ciano Claro", rgb: [0, 255, 200] },
            { name: "Laranja", rgb: [200, 100, 0] },
            { name: "Roxo", rgb: [150, 0, 150] },
            { name: "Amarelo Esverdeado", rgb: [200, 255, 0] },
            { name: "Branco Esverdeado", rgb: [230, 255, 230] }
        ]
    },
{
    name: "VsCode UI",
    colors: [
        { name: "Inputs", rgb: [43, 43, 43] },
        { name: "Fundo do Editor", rgb: [30, 30, 30] },
        { name: "Hover", rgb: [42, 45, 46] },
        { name: "Fundo de Barras", rgb: [37, 37, 38] },
        { name: "Fundo de Painéis", rgb: [45, 45, 48] },
        { name: "Bordas e Separadores", rgb: [62, 62, 66] },
        { name: "Seleção", rgb: [38, 79, 120] },
        { name: "Destaque 1", rgb: [14, 99, 156] },
        { name: "Botões", rgb: [14, 99, 156] },
        { name: "Elementos Interativos", rgb: [0, 122, 204] },
        { name: "Foco Primário", rgb: [0, 122, 204] },
        { name: "Guias Ativas", rgb: [0, 122, 204] },
        { name: "Destaque 2", rgb: [86, 156, 214] },
        { name: "Texto Secundário", rgb: [180, 180, 180] },
        { name: "Texto Primário", rgb: [212, 212, 212] },
        { name: "Texto sobre Destaque", rgb: [255, 255, 255] }
    ]
},    
    {
        name: "Alto Contraste",
        colors: [
            { name: "Preto", rgb: [0, 0, 0] },
            { name: "Preto", rgb: [0, 0, 0] },
            { name: "Preto", rgb: [0, 0, 0] },
            { name: "Preto", rgb: [0, 0, 0] },
            { name: "Preto", rgb: [0, 0, 0] },
            { name: "Preto", rgb: [0, 0, 0] },
            { name: "Preto", rgb: [0, 0, 0] },
            { name: "Preto", rgb: [0, 0, 0] },
            { name: "Amarelo", rgb: [255, 255, 0] },
            { name: "Ciano", rgb: [0, 255, 255] },
            { name: "Verde", rgb: [0, 255, 0] },
            { name: "Magenta Claro", rgb: [255, 128, 255] },
            { name: "Vermelho Claro", rgb: [255, 128, 128] },
            { name: "Azul Claro", rgb: [173, 216, 230] },
            { name: "Branco", rgb: [255, 255, 255] },
            { name: "Branco", rgb: [255, 255, 255] }
        ]
    }


];

let currentPalette = 0;

// Função para gerar os botões de seleção de paleta
function generatePaletteSelector() {
    const selector = document.getElementById('palette-selector');
    selector.innerHTML = '';
    
    palettes.forEach((palette, index) => {
        const button = document.createElement('div');
        button.className = `palette-option ${index === currentPalette ? 'active' : ''}`;
        button.textContent = palette.name;
        button.style.background = `rgb(${palette.colors[1].rgb.join(',')})`;
        button.style.color = `rgb(${palette.colors[15].rgb.join(',')})`;
        button.style.borderColor = `rgb(${palette.colors[9].rgb.join(',')})`;
        
        button.addEventListener('click', () => {
            selectPalette(index);
        });
        
        selector.appendChild(button);
    });
}

// Função para gerar a exibição da paleta
function generatePaletteDisplay() {
    const display = document.getElementById('palette-display');
    display.innerHTML = '';
    
    palettes[currentPalette].colors.forEach((color, index) => {
        const colorElement = document.createElement('div');
        colorElement.className = 'color-item';
        colorElement.textContent = index;
        colorElement.style.background = `rgb(${color.rgb.join(',')})`;
        
        // Escolher cor do texto com base no brilho do fundo
        const brightness = (color.rgb[0] * 299 + color.rgb[1] * 587 + color.rgb[2] * 114) / 1000;
        colorElement.style.color = brightness > 125 ? '#000' : '#fff';
        
        colorElement.title = `${color.name} (RGB: ${color.rgb.join(', ')})`;
        
        display.appendChild(colorElement);
    });
}

// Função para selecionar uma paleta
function selectPalette(index) {
    currentPalette = index;
    
    // Atualizar botões
    document.querySelectorAll('.palette-option').forEach((button, i) => {
        button.classList.toggle('active', i === index);
        button.style.background = `rgb(${palettes[i].colors[1].rgb.join(',')})`;
        button.style.color = `rgb(${palettes[i].colors[15].rgb.join(',')})`;
        button.style.borderColor = `rgb(${palettes[i].colors[9].rgb.join(',')})`;
    });
    
    // Atualizar exibição da paleta
    generatePaletteDisplay();
    
    // Atualizar console
    updateConsoleTheme();
}

// Função para atualizar o tema do console
function updateConsoleTheme() {
    const consoleElement = document.getElementById('console');
    const palette = palettes[currentPalette];
    
    consoleElement.style.background = `rgb(${palette.colors[0].rgb.join(',')})`;
    consoleElement.style.color = `rgb(${palette.colors[15].rgb.join(',')})`;
    consoleElement.style.borderColor = `rgb(${palette.colors[8].rgb.join(',')})`;
    
    // Atualizar texto de comando
    document.querySelectorAll('.cmd-text').forEach(el => {
        el.style.color = `rgb(${palette.colors[10].rgb.join(',')})`;
    });
    
    // Atualizar a linha que mostra a paleta atual
    const lines = consoleElement.querySelectorAll('.console-line');
    if (lines.length > 3) {
        lines[3].textContent = `>> Paleta atual: ${palette.name}`;
    }
}

// Inicializar a aplicação
function init() {
    generatePaletteSelector();
    generatePaletteDisplay();
    updateConsoleTheme();
}

// Executar quando a página carregar
window.addEventListener('load', init);