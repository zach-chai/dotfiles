require 'rake'
require 'erb'

desc "install the dot files into user's home directory"
task :install, :automated do |t, args|
  @automated = automated args
  replace_all = @automated == 'replace'
  skip_all = @automated == 'skip'

  Dir['*'].each do |file|
    next if %w[Rakefile README.rdoc LICENSE install.sh gitconfig.template].include? file

    if File.exist?(File.join(ENV['HOME'], ".#{file.sub('.erb', '')}"))
      if File.identical? file, File.join(ENV['HOME'], ".#{file.sub('.erb', '')}")
        puts "identical ~/.#{file.sub('.erb', '')}"
      elsif replace_all
        replace_file(file)
      else
        if skip_all
          choice = 'n'
        else
          print "overwrite ~/.#{file.sub('.erb', '')}? [ynaq] "
          choice = $stdin.gets.chomp
        end
        case choice
        when 'a'
          replace_all = true
          replace_file(file)
        when 'y'
          replace_file(file)
        when 'q'
          exit
        else
          puts "skipping ~/.#{file.sub('.erb', '')}"
        end
      end
    else
      link_file(file)
    end
  end

  unless Dir.exist?(File.join(ENV['HOME'], ".oh-my-zsh"))
    puts "Installing oh-my-zsh"
    system %Q{git clone git://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh}
  end
end

def replace_file(file)
  system %Q{rm -rf "$HOME/.#{file.sub('.erb', '')}"}
  link_file(file)
end

def link_file(file)
  if file =~ /.erb$/
    puts "generating ~/.#{file.sub('.erb', '')}"
    File.open(File.join(ENV['HOME'], ".#{file.sub('.erb', '')}"), 'w') do |new_file|
      new_file.write ERB.new(File.read(file)).result(binding)
    end
  else
    puts "linking ~/.#{file}"
    system %Q{ln -s "$PWD/#{file}" "$HOME/.#{file}"}
  end
end

def automated(args)
  if args[:automated]
    args[:automated].downcase
  else
    nil
  end
end
