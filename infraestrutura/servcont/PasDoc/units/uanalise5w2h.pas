unit uAnalise5w2h;
{:< Implementação da classe base TAnalise5w2h cujo o objetivo é permitir que
  a documentação tenha um padrão de qualidade japonês chamado [5w2h](https://ferramentasdaqualidade.org/5w2h).
}
{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils;

Type
  { TAnalise5w2h }
  {: [O que é 5W2H?](https://ferramentasdaqualidade.org/5w2h)
     - Criado na indústria automobilística japonesa durante a condução de
       estudos sobre qualidade, hoje o 5W2H é considerado uma ferramenta
       administrativa e da qualidade que pode ser aplicada em várias áreas
       de negócio e em diferentes contextos dentro de uma organização,
       como no planejamento estratégico para organizar e guiar a execução
       de ações dentro da empresa ou até mesmo para planejar uma viagem de
       negócios.
       [Veja mais](https://ferramentasdaqualidade.org/5w2h)
  }
  TAnalise5w2h = class

    {: WHAT
         - Aqui deve-se determinar a intenção do que se pretende realizar,
           ou seja, definir e descrever o que será feito de fato. Por exemplo:
           criação de um ambiente de descanso e leitura para colaboradores.
    }
    protected procedure O_que_sera_feito;virtual; abstract;// = 'WHAT';

    {: WHY
         - Trata-se da justificativa para o desenvolvimento do que foi
            proposto. Por exemplo: para proporcionar uma oportunidade de
            relaxamento e pausa para melhorar a qualidade de vida dos
            colaboradores e consequentemente enriquecendo suas entregas.
    }
    protected procedure Por_que_sera_feito;virtual; abstract;// 'WHY' ;

    {: WHERE
         - Definição do local de realização. Este local pode ser físico
           ou até mesmo um departamento ou setor de uma empresa. Por
           exemplo: na sala 2 disponível no subsolo da empresa.
    }
    protected procedure Onde_sera_feito;virtual; abstract; // 'WHERE';

    {: WHEN
         - O tempo de execução;
         - cronograma de execução;
         - prazos para a execução.
    }
    protected procedure Quando_sera_Feito;virtual; abstract; //= 'WHEN';

    {: WHO
         - Deve-se definir quem ou qual área será responsável pela execução
           do que foi definido. Por mais que uma área seja a responsável,
           uma boa prática é escolher um líder, ou seja, alguém que será
           encarregado de gerenciar a execução do que foi proposto.
    }
    protected procedure Por_quem_sera_feito;virtual; abstract;// = 'WHO';

    {: HOW
         - Os métodos ou estratégias utilizadas para a condução do que foi
           estabelecido devem ser definidos, para que, o que foi idealizado,
           seja executado da melhor forma possível.
    }
    protected procedure Como_sera_feito;virtual; abstract;// = 'HOW';

    {: HOW MUCH
        - Definição do custo e investimento necessário para a realização
          do que foi proposto.
    }
    protected procedure Quanto_custara;virtual; abstract;// =  'HOW MUCH';

  end;

implementation

end.


