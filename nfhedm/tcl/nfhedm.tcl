
package require turbine 0.1

namespace eval tclfop {

    proc fop_sanity { } {
        puts "fop_sanity{}: OK"
    }

    proc FitOrientation_Tcl { } { 
        set result [ blobutils_malloc [ expr 4 * [ blobutils_sizeof_float ] ] ]
        set result [ blobutils_cast_to_dbl_ptr $result ]
        FitOrientation_Swift "data/Parameters2.txt" 1 $result
        
        for { set i 0 } { $i < 4 } { incr i } { 
            set v [ blobutils_get_float $result $i ] 
            puts "result\[$i\]: $v"
        }

        blobutils_free $result
    }
}
