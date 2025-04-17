{#
    This macro returns the subscriber type
#}

{% macro get_subscriber_type(subscriber_type) -%}

    case 
        when subscriber_type = 'nan' then c_subscription_type
        else subscriber_type
    end 

{%- endmacro %}