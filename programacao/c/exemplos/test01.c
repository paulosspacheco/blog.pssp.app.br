/******************************************************************************

Welcome to GDB Online.
GDB online is an online compiler and debugger tool for C, C++, Python, Java, PHP, Ruby, Perl,
C#, VB, Swift, Pascal, Fortran, Haskell, Objective-C, Assembly, HTML, CSS, JS, SQLite, Prolog.
Code, Compile, Run and Debug online from anywhere in world.

*******************************************************************************/

/**
 * Este progragrama ler um número e imprime todos os número até zero.
*/
#include <stdio.h>

int main()
{
    /**
     * Declara a váriavel n como inteiro
    */
    int n = 1;
    int i = 0;
   
    
    /**
     * Imprime na tela para o usuário digitar um número
    */
    printf("Informe o valor de n:");
    /**
     * Ler do teclado um número inteiro.
    */
    scanf("%d",&n);

    // Iniciar i com o valor de n
    i = n; //Contador

    /**
     * Entra no laço
    */
    while (i >=0) {
        //Imprime o valor i.
        printf("Valor de i = %d\n",i);
        
        // subtrai 2 de i
        i = i - 2;
    } 
    
    //Fim do programa    
    return 0;
}
