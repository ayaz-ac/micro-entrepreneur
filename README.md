# README

## Environnement

- Ruby: 3.4.8
- Rails: 8.1.1
- Postgresql
- Importmap
- Hotwire

## Configuration obligatoire
- [x] Générer une clé `master.key` et le fichier `credentials.yml.enc` `rails credentials:edit`
- [x] Faire une recherche du mot "MicroEntrepreneur" dans le projet et modifier toutes les occurrences
- [x] Changer le texte du CTA (en faisant une recherche du mot *cta* dans le projet)
- [x] Mettre à jour les couleurs du thème en modifiant le fichier `tailwind.config.js`
- [x] Modifier les polices en mettant à jour les liens GoogleFonts et en modifiant le fichier `tailwind.config.js`
- [x] Saisir l'adresse e-mail de contact `[adresse e-mail de contact]` pour la politique de confidentialité et les CGU dans: `app/views/pages/privacy` et `app/views/pages/terms`
- [x] Créer les fichiers `favicon.ico` pour toutes les plateformes => https://realfavicongenerator.net/favicon/ruby_on_rails
- [ ] Modifier les SEO Tags dans `config/meta.yml` et créer des images pour les réseaux sociaux en 1200x660 (`opengraph-cover.jpg` et `twitter-cover.jpg`)

## Stripe configuration

Pour configurer stripe en mode abonnement avec 2 produits (Starter et Business)

```
 rails g stripe_setup
```

Pour configurer Stripe en mode **payment en une fois** avec un 1 seul produit

```
rails g stripe_setup --mode payment
```
---
### Après la configuration de Stripe
- [ ] Mettre à jour les credentials (un exemple se trouve dans `config/credentials.example`)
- [ ] Créer des formulaires POST avec comme url le *CheckoutSessionsController* et en passant le `price_id` en paramètre
- [ ] [Mettre à jour les paramètres Devise](https://github.com/heartcombo/devise#strong-parameters) pour prendre en compte les nouveaux champs
- [ ] Mettre à jour le formulaire d'inscription pour ajouter les nouveaux champs
- [ ] Ajouter un callback de type `before_action` pour éviter de donner l'accès au formulaire sans passer par Stripe
