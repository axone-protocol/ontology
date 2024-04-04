:- discontiguous([title/2,partOf/2,chapter/1,section/1,article/1,paragraph/2]).
chapter('chap1').
     title('chap1', 'Crime data governance').
     section('sec1.1').
         partOf('sec1.1', 'chap1').
         title('sec1.1', 'Usage of the dataset').
             article('art1.1.1').
                 partOf('art1.1.1', 'sec1.1').
                 title('art1.1.1', 'Conditions on consumers').
                 paragraph('para1.1.1.1', permitted) :- action(A), A=='workflow:consume'.
                    partOf('para1.1.1.1', 'art1.1.1.1').
                    description('para1.1.1.1', 'Everyone can use the dataset').