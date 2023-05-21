| Category   | Faille de sécurité                                   | Prévention                                                      | Id         | Status |
|------------|------------------------------------------------------|--------------------------------------------------------------------------|------------|--------|
| Code       | Utilisation de la fonction exec détectée             | Utiliser des alternatives sécurisées à la fonction exec                  | S1_bandit  |&#10005;|
|            | Possible liaison à toutes les interfaces             | Limiter la liaison aux interfaces nécessaires                            | S2_bandit  |&#10005;|
|            | Appel à la bibliothèque Requests sans délai          | Spécifier un délai d'expiration pour les appels à Requests               | S3_bandit  |&#10005;|
|            | Possible mot de passe codé en dur                    | Stocker les informations sensibles de manière sécurisée                  | S4_bandit  |&#10004;|
|            | Possible secret codé en dur                          | Utiliser des mécanismes de gestion des secrets sécurisés                 | S5_bandit  |&#10004;|
|            | Possible identifiants codés en dur                   | Utiliser des méthodes d'authentification sécurisées                      | S6_bandit  |&#10004;|

