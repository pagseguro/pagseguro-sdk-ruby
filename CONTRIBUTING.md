PagSeguro is the a library to use [pagseguro's API](https://pagseguro.uol.com.br).

It is officially maintened by pagseguro company.

Please note that these rules should be acknowledged by everyone, but repository contributors might occasionally deviate from them for practical work, e.g. not fork the repository, but using a branch on the main repository. This should however be an exception.

# Developing

Please follow this steps:

* *Fork* the project at github;

* git clone your project, using:

    % git clone git@github.com/<your-username-here>/ruby

* Optionaly you can add main repository as upstream:

    % git remote add upstream git@github.com:pagseguro/ruby.git

* Make sure you are on the right branch, aka, `dev`:

    % git checkout dev

* Create your develop/feature branch:

    % git checkout -b my-cool-feature

* Make your changes of the files and, of course, ensure you write the related tests.

* Send your work to your repository:

    % git push origin my-cool-feature

* Now, create a pull request using github. Don't forget to include a clear description of what the pull request want to change and/or fix.

# Test

It is essential, PR without tests will not be accepted (unless rare ocasions, e. g., changing examples, documentation, …).
