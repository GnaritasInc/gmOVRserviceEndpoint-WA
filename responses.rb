$responses=[]

  
def firstResponder(json) 
    matches = $responses.find { |rule| testRule(rule,json) } #(matchPattern)select {|k, _| k.include? str} 
    matches ? matches[:response]: nil
end

def  makeResponse(token,returnCode,errorCode,errorMessage)
    #return {'bar':'baz'}.to_json
  return  {'returnToken':token, 'transactionID':'12345', 'returnCode':returnCode, 'errorCode':errorCode, 'errorMessage':errorMessage}.to_json

end

def errorResponse (returnCode,errorCode, errorMessage)
    makeResponse('',returnCode,errorCode,errorMessage)
end

def testRule(responseRule,json)
    regex = Regexp.new responseRule[:pattern]
    return json.to_s.match(regex)

end


def makeResponseRule(pattern, response)
    return {pattern: pattern, response:response}
end


def registerResponseRule (pattern, response)
    $responses.push makeResponseRule(pattern,response)
end

def registerRules
    registerResponseRule 'DO NOT MATCH ME', "This is a first response"

    registerResponseRule '"customerID"=>""', errorResponse('M','0200', 'Missing customer id')
    registerResponseRule '"resAddressChangeMadeDate"=>"1/2/20000"', errorResponse('M','0300', 'Resident Address change made date is not a valid date')
    registerResponseRule '"residenceZip"=>"98000"', errorResponse('M','0400', 'Resident zip is not between 98001 and 99403')
    registerResponseRule '"firstName"=>"fnamefname', errorResponse('M','0500', 'Truncating firstName because it was too long')
    registerResponseRule '"firstName"=>"A12345678901234567890123456789012345678901234567890', errorResponse('M','0500', 'Truncating firstName because it was too long')
    registerResponseRule '"mailingZip"=>"1/2/20000"', errorResponse('M','0600', 'Zip is not numeric')
    registerResponseRule '"mailCountyCode"=>"0a"', errorResponse('M','0700', 'mailCountyCode is not numeric')
    registerResponseRule '"firstName"=>"Voldemort"', errorResponse('E','1000', 'Access denied')
    
    registerResponseRule '.*', makeResponse('superAwesomeToken','S','0000','')

    

    registerResponseRule '.*', errorResponse('M','0042', 'Last Response Error. Should not get this.')
end

registerRules()
