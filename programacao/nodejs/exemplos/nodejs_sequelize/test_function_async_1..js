   function palhaço_assustador() {
        return new Promise(
                     resolve => {setTimeout(() => { resolve('🤡');}, 2000);});
    }

    async function msg() {
        const msg = await palhaço_assustador();
        console.log('Message:', msg);
    }

    msg(); // Message: 🤡 <-- after 2 sec