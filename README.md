# README #


### What is this repository for? ###

* Quick summary

Ce projet a consisté au développement d’un système de paiement simple, léger et facilement déployable. Le système est composé de deux applications clientes, l’une pour les vendeurs et l’autre pour les acheteurs. Il comprend également un serveur qui constitue le cœur du système.
Un des points du cahier des charges est que les application clientes doivent tourner sur iOS. Elles ont par conséquent été développées avec le langage Swift (voir 8.4.1.6) et en utilisant les nombreuses librairies proposées par le gestionnaire de paquets CocoaPods (voir 8.5.1 ou 8.6.1).
Le serveur quant à lui a été développé en Java avec le Framework Spring (voir 8.4.1.1). Il expose une API Rest vers l’extérieur.
Toutes les fonctionnalités demandées dans le cahier des charges ont été implémentées. Pour que le système soit utilisable, il faudrait encore développer l’application administrateur qui, à la date de rendu de ce rapport, n’est pas encore disponible.

Des tests globaux des fonctionnalités et de la sécurité ont étés effectués. Quelques corrections ont dû être faites pour que tout fonctionne bien et que tout soit correctement sécurisé.
Une analyse sécuritaire complète du système de paiement a été également effectuée. Les menaces, les vulnérabilités et les risques d’un tel système y sont relevées. Les contremesures déjà implémentées de base par le fabriquant des appareils et celles implémentées au cours du développement y sont décrites.
A la fin du rapport vous trouverez également quelques idées pour les développements futurs. Comme par exemple la création d’un ticket à l’aide d’une base de données des produits vendus qui permettrait d’avoir une gestion des inventaires automatique.


* Version

1.0

### Who do I talk to? ###

* HEIG-VD
* Haute Ecole d'Ingénierie et de Gestion du Canton de Vaud

* Département TIC - Télécommunication - Sécurité Informatique
* Bastian Gardel 
* bastian.gardel@heig-vd.ch