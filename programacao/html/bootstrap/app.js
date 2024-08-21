const BASE_URL = 'http://localhost:8080/TUsuarioController/';

// Função para mostrar o status na página
function showStatus(elementId, message) {
    document.getElementById(elementId).innerText = message;
}

// Create User
document.getElementById('createForm').addEventListener('submit', function(event) {
    event.preventDefault();
    const login = document.getElementById('createLogin').value;
    const nome = document.getElementById('createNome').value;

    fetch(BASE_URL + 'CreateUsuario', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
        },
        body: JSON.stringify({ login: login, nome: nome }),
    })
    .then(response => response.json())
    .then(data => {
        showStatus('statusCreateResult', data.message || 'User created successfully!');
    })
    .catch(error => {
        showStatus('statusCreateResult', 'Error: ' + error.message);
        console.error('Error:', error);
    });
});

// Get User
document.getElementById('getForm').addEventListener('submit', function(event) {
    event.preventDefault();
    const id = document.getElementById('getId').value;

    fetch(BASE_URL + 'GetUsuario?id=' + id)
    .then(response => response.json())
    .then(data => {
        const resultDiv = document.getElementById('getUserResult');
        if (data && data.id) {
            resultDiv.innerHTML = `<p>ID: ${data.id}</p><p>Login: ${data.login}</p><p>Name: ${data.nome}</p>`;
        } else {
            resultDiv.innerHTML = '<p>User not found.</p>';
        }
    })
    .catch(error => {
        showStatus('statusGetResult', 'Error: ' + error.message);
        console.error('Error:', error);
    });
});

// Update User
document.getElementById('updateForm').addEventListener('submit', function(event) {
    event.preventDefault();
    const id = document.getElementById('updateId').value;
    const login = document.getElementById('updateLogin').value;
    const nome = document.getElementById('updateNome').value;

    fetch(BASE_URL + 'UpdateUsuario', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
        },
        body: JSON.stringify({ id: id, login: login, nome: nome }),
    })
    .then(response => response.json())
    .then(data => {
        showStatus('statusUpdateResult', data.message || 'User updated successfully!');
    })
    .catch(error => {
        showStatus('statusUpdateResult', 'Error: ' + error.message);
        console.error('Error:', error);
    });
});

// Delete User
document.getElementById('deleteForm').addEventListener('submit', function(event) {
    event.preventDefault();
    const id = document.getElementById('deleteId').value;

    fetch(BASE_URL + 'DeleteUsuario', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: new URLSearchParams({ id: id }),
    })
    .then(response => response.json())
    .then(data => {
        showStatus('statusDeleteResult', data.message || 'User deleted successfully!');
    })
    .catch(error => {
        showStatus('statusDeleteResult', 'Error: ' + error.message);
        console.error('Error:', error);
    });
});
