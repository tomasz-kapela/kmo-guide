# GIT & GitHub

W przykładach `tomasz-kapela` to nazwa konta na githubie i należy ją zmienić na własną.

## Klonowanie repozytorium z GitHuba

Aby stworzyć lokalną kopię (sklonować) publicznego repozytorium z **GitHuba** nie trzeba mieć tam konta.
Konto jest potrzebne aby klonować prywatne repozytoria i wgrywać do nich poprawki. 

```bash
git clone github-path [local_name]

git clone https://github.com/tomasz-kapela/kmo-guide.git 
```

### Dostęp do prywatnych repozytoriów

#### Przez HTTPS

```bash
git clone https://github.com/tomasz-kapela/PRIVATE-PROJECT.git
```

W tym celu na stronie 
<tt>GitHub / User Menu / Settings / Developer Setting / Personal access tokens / Tokens</tt>
należy wygenerować **TOKEN** ustawiając opowiednie uprawnienia (przynajmniej **repo**).
Przy klonowaniu podajemy **EMAIL** jako login a **TOKEN** jako hasło.

#### [Przez SSH](https://docs.github.com/en/authentication/connecting-to-github-with-ssh)

```bash
git clone git@github.com:tomasz-kapela/PRIVATE-PROJECT.git
```

W tym celu konieczne jest wygenerowanie kluczy prywatnego i publicznego (jeżeli go jeszcze nie mamy) 

```bash
ssh-keygen -t ed25519 -C "your_email@example.com"
```

a następnie dodania publicznego klucza e.g. id_ed25519.pub na stronie 
<tt>GitHub / User Menu / Settings / SSH an GPG keys</tt> 

#### Kilka kont na GitHubie

Jeżeli mamy kilka kont na githubie to można wygenerować osobne klucze dla drugiego konta np. o nazwie `KeyForXX`  
i w pliku `.ssh/config` dodać konfigurację aby dla drugiego konta używał klucza `KeyForXX` 

```
Host github-XX
	HostName github.com
	User git
  IdentityFile ~/.ssh/KeyForXX
```

Wtedy klonujemy podając `github-XX` zamiast `github.com` w ścieżce.

```bash
git clone git@github-XX:tomasz-kapela/PRIVATE-PROJECT.git
```
