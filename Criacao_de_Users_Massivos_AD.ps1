# Importsr o modulo de Active Directory para o PowerShell
Import-Module ActiveDirectory
  
# Guardar a informação contida no ficheiros csv na variavel $ADUsers
$ADUsers = Import-Csv C:\PBLAB\users1.csv

# Define o UPN (User Principal Name)
$UPN = "pblab.com"

# Loop por cada linha que contem os detalhes dos utilizadores no ficheiro csv
foreach ($User in $ADUsers) {

    # Lê a informação de cada campo do utilizador em cada linha e atribui o valor a uma variavel 
    $username = $User.username
    $password = $User.password
    $firstname = $User.firstname
    $lastname = $User.lastname
    $initials = $User.initials
    $OU = $User.ou #This field refers to the OU the user account is to be created in
    $email = $User.email
    $streetaddress = $User.streetaddress
    $city = $User.city
    $zipcode = $User.zipcode
    $state = $User.state
    $country = $User.country
    $telephone = $User.telephone
    $jobtitle = $User.jobtitle
    $company = $User.company
    $department = $User.department

    # Verifica se o utilizador já existe na AD
    if (Get-ADUser -F { SamAccountName -eq $username }) {
        
        # Se o utilizador já existe dar um aviso
        Write-Warning "A user account with username $username already exists in Active Directory."
    }
    else {

        # Utilizador não existe o processo segue
        # Conta sera criada na OU providenciada pela variavel $OU lida do ficheiro csv
        New-ADUser `
            -SamAccountName $username `
            -UserPrincipalName "$username@$UPN" `
            -Name "$firstname $lastname" `
            -GivenName $firstname `
            -Surname $lastname `
            -Initials $initials `
            -Enabled $True `
            -DisplayName "$lastname, $firstname" `
            -Path $OU `
            -City $city `
            -PostalCode $zipcode `
            -Country $country `
            -Company $company `
            -State $state `
            -StreetAddress $streetaddress `
            -OfficePhone $telephone `
            -EmailAddress $email `
            -Title $jobtitle `
            -Department $department `
            -AccountPassword (ConvertTo-secureString $password -AsPlainText -Force) -ChangePasswordAtLogon $True

        # Se o utilizador foi criado, mostrar a mensagem.
        Write-Host "The user account $username is created." -ForegroundColor Cyan
    }
}

Read-Host -Prompt "Press Enter to exit"
