module Betty
$executors = []
dirs=Dir[File.dirname(__FILE__) + '/betty/lib/*.rb']  rescue []#Exception => e
# raise "can't access betty dirs" if dirs==[]
puts "WARN betty dirs NOT available" if dirs==[]
dirs.each {|file|
  begin
    require file
  rescue Exception => e
    puts "Module #{file} could not be loaded because of #{e.message.split('\n')[0]}"
  end
}


def interpret(command)
  responses = []
  $executors.each do |executor|
    executors_responses = executor.interpret(command)
    responses = responses.concat(executors_responses)
    if executors_responses.length == 1 and executors_responses[0][:command]
      $LOG.info('main_interpret') {"#{command} ==> #{executor.name} ==> #{executors_responses[0][:command]}"}
    end
  end
  responses
end

end
