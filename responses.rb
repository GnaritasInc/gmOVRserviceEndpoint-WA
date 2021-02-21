$RESPONSES=[]
  
def first_responder(json) 
  match = $RESPONSES.find { |rule| test_rule(rule,json) } 
  match ? instantiate_rule(json, match): nil
end

def instantiate_rule (json, response_rule)
  match = test_rule(response_rule, json)
  response_json = response_rule[:response].to_json
  match.captures.map.with_index do |item, index| {
      response_json=response_json.gsub!(('$'+index.to_s),item) 
  }
  return JSON.parse(response_json)
end

def  make_response(token,return_code,error_code,error_message)
  return  {'returnToken':token, 'transactionID':'12345', 'return_code':return_code, 'error_code':error_code, 'error_message':error_message}.to_json
end

def error_response (return_code,error_code, error_message)
  make_response('',return_code,error_code,error_message)
end

def test_rule(response_rule,json)
  regex = Regexp.new response_rule[:pattern], Regexp::IGNORECASE
  return json.to_s.match(regex) 
end

def make_response_rule(pattern, response)
  return {pattern: pattern, response:response}
end

def register_response_rule (pattern, response)
  $RESPONSES.push make_response_rule(pattern,response)
end

def register_rules
  register_response_rule 'DO NOT MATCH ME', "This is a first response"

  register_response_rule '"customerID"=>""', error_response('M','0200', 'Missing customer id')
  register_response_rule '"resAddressChangeMadeDate"=>"1/2/20000"', error_response('M','0300', 'Resident Address change made date is not a valid date')
  register_response_rule '"residenceZip"=>"98000"', error_response('M','0400', 'Resident zip is not between 98001 and 99403')
  register_response_rule '"firstName"=>"fnamefname', error_response('M','0500', 'Truncating firstName because it was too long')
  register_response_rule '"firstName"=>"A12345678901234567890123456789012345678901234567890', error_response('M','0500', 'Truncating firstName because it was too long')
  register_response_rule '"mailingZip"=>"1/2/20000"', error_response('M','0600', 'Zip is not numeric')
  register_response_rule '"mailCountyCode"=>"0a"', error_response('M','0700', 'mailCountyCode is not numeric')
  register_response_rule '"firstName"=>"Voldemort"', error_response('E','1000', 'Access denied')
 
  register_response_rule '"(.*)"=>"Error:([^:]*):([^"]*)"', error_response('E','$1', 'Generated error $1 with field $0: $2')

  register_response_rule '.*', make_response('superAwesomeToken','S','0000','')
  register_response_rule '.*', error_response('M','0042', 'Last Response Error. Should not get this.')
end

register_rules
