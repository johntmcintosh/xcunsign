#!/usr/bin/env ruby
# Reference: https://github.com/fastlane/fastlane/blob/master/fastlane/lib/fastlane/actions/verify_xcode.rb

def verify_codesign(params)

    path = params[:xcode_path]
    puts "Verifying signature for #{path}"
    codesign_output = %x[ codesign --display --verbose=4 #{path} 2>&1 ]

    # If the returned codesign info contains all entries for any one of these sets, we'll consider it valid
    accepted_codesign_detail_sets = [
        [ # Found on App Store installed Xcode installations
            "Identifier=com.apple.dt.Xcode",
            "Authority=Apple Mac OS Application Signing",
            "Authority=Apple Worldwide Developer Relations Certification Authority",
            "Authority=Apple Root CA",
            "TeamIdentifier=59GAB85EFG"
        ],
        [ # Found on Xcode installations (pre-Xcode 8) downloaded from developer.apple.com
            "Identifier=com.apple.dt.Xcode",
            "Authority=Software Signing",
            "Authority=Apple Code Signing Certification Authority",
            "Authority=Apple Root CA",
            "TeamIdentifier=not set"
        ],
        [ # Found on Xcode installations (post-Xcode 8) downloaded from developer.apple.com
            "Identifier=com.apple.dt.Xcode",
            "Authority=Software Signing",
            "Authority=Apple Code Signing Certification Authority",
            "Authority=Apple Root CA",
            "TeamIdentifier=59GAB85EFG"
        ]
    ]

    # Map the accepted details sets into an equal number of sets collecting the details for which
    # the output of codesign did not have matches
    missing_details_sets = accepted_codesign_detail_sets.map do |accepted_details_set|
        accepted_details_set.reject { |detail| codesign_output.include?(detail) }
    end

    validated = missing_details_sets.any? { |set| set.empty? }
    puts "Codesigned: #{validated}"
    return validated ? 0 : 1

end

exit verify_codesign(xcode_path: ARGV[0])
