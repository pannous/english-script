class Betty
$executors = []

Dir[File.dirname(__FILE__) + '/betty/lib/*.rb'].each {|file|
  try:
    require file
  except Exception => e
    puts "Module #{file} could not be loaded because of #{e.message.split('\n')[0]}"

)
def interpret(command):
  responses = []
  $executors.each do |executor|
    executors_responses = executor.interpret(command)
    responses = responses.concat(executors_responses)
    if executors_responses.length == 1 and executors_responses[0][:command]
      $LOG.info('main_interpret') {"#{command} ==> #{executor.name} ==> #{executors_responses[0][:command]}"}


  responses
