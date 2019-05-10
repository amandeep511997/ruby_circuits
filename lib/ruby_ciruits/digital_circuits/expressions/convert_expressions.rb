def make_compatible(expr)
	# converting logical symbols to english keywords
	expr = expr.gsub('~&', ' NAND ')
    expr = expr.gsub('~|', ' NOR ')
    expr = expr.gsub('~^', ' XNOR ')
    expr = expr.gsub('&', ' AND ')
    expr = expr.gsub('|', ' OR ')
    expr = expr.gsub('~', ' NOT ')
    expr = expr.gsub('^', ' XOR ')
    return '((' + expr + '))'
end

def create_list(expr)
	list1 = expr.split('(')
	list2 = Array.new
	list3 = Array.new

    if list1.include?('')
        list1.delete('')
    end

    list1.each do |str|
        l = str.split
        list2.concat(l)
    end

    list2.each do |str|
        sublist = Array.new
        if str.include?(')')
            while str.include?(')')
                idx = str.index(')')
                sublist << str[0, idx]
                sublist << ')'
                str = str[idx + 1, str.length - (idx + 1)]
            end
            sublist << str
            list3.concat(sublist)
        else
            list3 << [str]
        end
    end

    if list3.include?('')
        list3.delete('')
    end    

    return list3
end

def merge_not(type, expr)
    # combines NOR gate with others to minimize the number of gates used.
    if expr[-1] == ')'
        idx = expr.index('(')
        gate = expr[0, idx].upcase

        if gate == "OR" and type == "general" 
            return ("NOR" + expr[idx, expr.length - idx])
        elsif gate == "AND" and type == "general"
            return ("NAND" + expr[idx, expr.length - idx])
        elsif gate == "NOT"
            return expr[idx + 1, expr.length - 2]
        elsif gate == "XOR" and type == "general"
            return ("XNOR" + expr[idx, expr.length - idx])     
        elsif gate == "XNOR" and type == "general"
            return ("XOR" + expr[idx, expr.length - idx])
        elsif gate == "NAND" and type == "general"
            return ("AND" + expr[idx, expr.length - idx])
        elsif gate == "NOR" and type == "general"
            return ("OR" + expr[idx, expr.length - idx])         
        end    
    end
    return ("NOT(" + expr + ")")
end

def to_and_or_not(gate, op1, op2)
    # convert a general two input gate and two of its operands to use 
    # only OR, NOT, or AND gates
    if gate == "AND" or gate == "OR"
        return (gate + '(' + op1 + ", " + op2 + ')')
    elsif gate == "NAND"
        return ("NOT(AND(" + '(' + op1 + ", " + op2 + ')')
    elsif gate == "NOR"
        return ("NOT(OR(" + '(' + op1 + ", " + op2 + ')')
    elsif gate == "XOR"
        return ("OR(AND(" + op1 + ", " + merge_not("general", op2) + "), AND(" + merge_not("general", op1) + ", " + op2 + "))")
    elsif gate == "XNOR"
        return ("OR(AND(" + merge_not("general", op1) + ", " + merge_not("general", op2) + "), AND(" + op1 + ", " + op2 + "))")
    end     
end

def to_nand(gate, op1 ,op2)
    # converts a general two input gate and two of its operands to use only NAND gates
    if gate == "AND"
        return ("NOT(NAND(" + op1 + ", " + op2 + "))")
    elsif gate == "OR"
        return ("NAND(" + merge_not("special", op1) + ", " + merge_not("special", op2) + ')')
    elsif gate == "NAND"
        return (gate + '(' + op1 + ", " + op2 + ')' )
    elsif gate == "NOR"
        return ("NOT(" + to_nand("OR", op1, op2) + ')')
    elsif gate == "XOR"
        return ("NAND(NAND(" + op1 + ", NAND(" + op1 + ", " + op2 + ")), NAND(" + op2 + ", NAND(" + op1 + ", " + op2 + ")))")
    elsif gate == "XNOR"
        return ("NOT(" + to_nand("XOR", op1, op2) + ')')
    end 
end

def to_nor(gate, op1 ,op2)
    # converts a general two input gate and two of its operands to use only NOR gates
    if gate == "OR"
        return ("NOT(NOR(" + op1 + ", " + op2 + "))")
    elsif gate == "AND"
        return ("NOR(" + merge_not("special", op1) + ", " + merge_not("special", op2) + ')')
    elsif gate == "NOR"
        return (gate + '(' + op1 + ", " + op2 + ')' )
    elsif gate == "NAND"
        return ("NOT(" + to_nor("AND", op1, op2) + ')')
    elsif gate == "XNOR"
        return ("NOR(NOR(" + op1 + ", NOR(" + op1 + ", " + op2 + ")), NOR(" + op2 + ", NOR(" + op1 + ", " + op2 + ")))")
    elsif gate == "XOR"
        return ("NOT(" + to_nor("XNOR", op1, op2) + ')')
    end
end

def remove_not(gate, exp)
    # convert a NOT gate and its operand to use the specified gate only
    # The input gate must be NAND or NOR only
    while exp.include?("NOT")
        idx = exp.index("NOT(")
        idx2 = idx 
        idx3 = exp.index('(', idx)
        while true
            idx2 = exp.index(')', idx2 + 1)
            idx3 = exp.index('(', idx3 + 1)
            if idx3 == nil or idx3 > idx2
                break
            end
        end
        exp = exp[0, idx] + gate + '(' + exp[idx + 4, idx2] + ", " + exp[idx + 4, idx2] + ')' + exp[idx2 + 1, exp.length]
    end
    return exp
end

def convert_expression(expr, two_input=0, only_nand=0, only_nor=0, only_and_or_not=0)
=begin
    Converts logical expression to an implementable form.
    Parameters : 
        - two_input = 1 ; if only two input gates must be used
        - only_nand = 1 ; if only two input nand gates must be used
        - only_nor = 1 ; if only two input nor gates must be used
        - only_and_or_not = 1 ; if only two input AND, OR and NOTs be used
    only one parameter can be set at a time, else error occurs.

    convert_expression('(NOT(A) and NOT(B)) or (C and NOT(D) and E and F)')
    =>  OR(AND(NOT(A), NOT(B), AND(C, NOT(D), E, F)))

=end
    expr = make_compatible(expr)
    list1 = create_list(expr)
    while list1.include?(')')
        idx = list1.index(')')
        if idx + 1 != list1.length and list1[idx + 1] == ')'
            last = 0
        else 
            last = 1
        end

        if list1.length > 1
            op2 = list1.delete_at(idx - 1)
            gate = list1.delete_at(idx - 2)
            gate = gate.upcase
            if gate != "NOT"
                op1 = list1.delete_at(idx - 3)
                if op1 == nil
                    list1.insert(idx - 1, gate)
                    list1.insert(idx - 2, op2)
                    break
                end
                previous_gate = op1[0, gate.length]
                previous_gate = previous_gate.upcase
                next_gate = op2[0, gate.length]
                next_gate = next_gate.upcase
                if (two_input == 0 and gate != "NAND" and gate != "NOR") and (only_nand == 0 and only_nor == 0 and only_and_or_not == 0) 
                    if gate == previous_gate and gate == next_gate.upcase
                        new_element = (gate + '(' + op1[gate.length + 1, op1.length - 1 - (gate.length + 1)] + ", " + op2[gate.length + 1, op2.length - 1 - (gate.length + 1)] + ')')
                    elsif gate == previous_gate and gate != next_gate.upcase 
                        new_element = (gate + '(' + op1[gate.length + 1, op1.length - 1 - (gate.length + 1)] + ", " + op2 + ')')
                    elsif gate != previous_gate and gate == next_gate.upcase
                        new_element = (gate + '(' + op1 + ", " + op2[gate.length + 1, op2.length - 1 - (gate.length + 1)] + ')')
                    else
                        new_element = (gate + '(' + op1 + ", " + op2 + ')')
                    end
                else
                    if only_nand == 0 and only_nor == 0 and only_and_or_not == 0
                        new_element = (gate + '(' + op1 + ", " + op2 + ')')
                    elsif only_nand == 1 and only_nor == 0 and only_and_or_not == 0
                        new_element = to_nand(gate, op1, op2)
                    elsif only_nand == 0 and only_nor == 1 and only_and_or_not == 0
                        new_element = to_nor(gate, op1, op2)
                    elsif only_nand == 0 and only_nor == 0 and only_and_or_not == 1
                        new_element = to_and_or_not(gate, op1, op2)
                    else
                        raise "invalid input"
                    end
                end
                list1.insert(idx - 3, new_element)
                if last != 1 or list1.index(')') == 1
                    temp1 = list1.index(')')
                    temp2 = list1.delete_at(temp1)
                end
            else
                if only_nand == 0 and only_nor == 0 and only_and_or_not == 0
                    new_element = merge_not("general", op2)
                else
                    new_element = merge_not("special", op2)
                end
                list1.insert(idx - 2, new_element)
                temp1 = list1.index(')')
                temp2 = list1.delete_at(temp1)
            end
            if list1.count(')') + 1 == list1.length
                break
            end
        end
    end

    if only_nand == 1
        return remove_not("NAND", list1[0])
    elsif only_nor == 1
        return remove_not("NOR", list1[0])
    else
        return list1[0]
    end
end
