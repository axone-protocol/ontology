:- discontiguous([title/2,partOf/2,chapter/1,section/1,article/1,paragraph/2]).
chapter('chap1').
     title('chap1', 'Collaborative AI zone governance').
     section('sec1.1').
         partOf('sec1.1', 'chap1').
         title('sec1.1', 'Zone Governance').
             article('art1.1.1').
                 partOf('art1.1.1', 'sec1.1').
                 title('art1.1.1', 'Conditions to amend the rules').
                 paragraph('para1.1.1.1', permitted) :- action(A), A=='governance:amend', subject(S), S == 'did:key:zQ3shs7auhJSmVJpiUbQWco6bxxEhSqWnVEPvaBHBRvBKw6Q3'.
                    partOf('para1.1.1.1', 'art1.1.1').
                    description('para1.1.1.1', 'Governance can only be amended by the identity `did:key:zQ3shs7auhJSmVJpiUbQWco6bxxEhSqWnVEPvaBHBRvBKw6Q3`').
