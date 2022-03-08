 f u n c t i o n   G e t - P r o d u c t K e y   {  
           < #        
         . S Y N O P S I S        
                 R e t r i e v e s   t h e   p r o d u c t   k e y   a n d   O S   i n f o r m a t i o n   f r o m   a   l o c a l   o r   r e m o t e   s y s t e m / s .  
                    
         . D E S C R I P T I O N        
                 R e t r i e v e s   t h e   p r o d u c t   k e y   a n d   O S   i n f o r m a t i o n   f r o m   a   l o c a l   o r   r e m o t e   s y s t e m / s .   Q u e r i e s   o f   6 4 b i t   O S   f r o m   a   3 2 b i t   O S   w i l l   r e s u l t   i n    
                 i n a c c u r a t e   d a t a   b e i n g   r e t u r n e d   f o r   t h e   P r o d u c t   K e y .   Y o u   m u s t   q u e r y   a   6 4 b i t   O S   f r o m   a   s y s t e m   r u n n i n g   a   6 4 b i t   O S .  
                  
         . P A R A M E T E R   C o m p u t e r n a m e  
                 N a m e   o f   t h e   l o c a l   o r   r e m o t e   s y s t e m / s .  
                    
         . N O T E S        
                 A u t h o r :   B o e   P r o x  
                 V e r s i o n :   1 . 1                
                         - U p d a t e   o f   f u n c t i o n   f r o m   h t t p : / / p o w e r s h e l l . c o m / c s / b l o g s / t i p s / a r c h i v e / 2 0 1 2 / 0 4 / 3 0 / g e t t i n g - w i n d o w s - p r o d u c t - k e y . a s p x  
                         - A d d e d   c a p a b i l i t y   t o   q u e r y   m o r e   t h a n   o n e   s y s t e m  
                         - S u p p o r t s   r e m o t e   s y s t e m   q u e r y  
                         - S u p p o r t s   q u e r y i n g   6 4 b i t   O S e s  
                         - S h o w s   O S   d e s c r i p t i o n   a n d   V e r s i o n   i n   o u t p u t   o b j e c t  
                         - E r r o r   H a n d l i n g  
            
         . E X A M P L E    
           G e t - P r o d u c t K e y   - C o m p u t e r n a m e   S e r v e r 1  
            
         O S D e s c r i p t i o n                                                                                       C o m p u t e r n a m e   O S V e r s i o n   P r o d u c t K e y                                        
         - - - - - - - - - - - - -                                                                                       - - - - - - - - - - - -   - - - - - - - - -   - - - - - - - - - -                                        
         M i c r o s o f t ( R )   W i n d o w s ( R )   S e r v e r   2 0 0 3 ,   E n t e r p r i s e   E d i t i o n   S e r v e r 1               5 . 2 . 3 7 9 0     b c d f g - h j k l m - p q r t t - v w x y y - 1 2 3 4 5            
                    
                 D e s c r i p t i o n    
                 - - - - - - - - - - -    
                 R e t r i e v e s   t h e   p r o d u c t   k e y   i n f o r m a t i o n   f r o m   ' S e r v e r 1 '  
         # >                    
         [ c m d l e t b i n d i n g ( ) ]  
         P a r a m   (  
                 [ p a r a m e t e r ( V a l u e F r o m P i p e L i n e = $ T r u e , V a l u e F r o m P i p e L i n e B y P r o p e r t y N a m e = $ T r u e ) ]  
                 [ A l i a s ( " C N " , " _ _ S e r v e r " , " I P A d d r e s s " , " S e r v e r " ) ]  
                 [ s t r i n g [ ] ] $ C o m p u t e r n a m e   =   $ E n v : C o m p u t e r n a m e  
         )  
         B e g i n   {        
                 $ m a p = " B C D F G H J K M P Q R T V W X Y 2 3 4 6 7 8 9 "    
         }  
         P r o c e s s   {  
                 F o r E a c h   ( $ C o m p u t e r   i n   $ C o m p u t e r n a m e )   {  
                         W r i t e - V e r b o s e   ( " { 0 } :   C h e c k i n g   n e t w o r k   a v a i l a b i l i t y "   - f   $ C o m p u t e r )  
                         I f   ( T e s t - C o n n e c t i o n   - C o m p u t e r N a m e   $ C o m p u t e r   - C o u n t   1   - Q u i e t )   {  
                                 T r y   {  
                                         W r i t e - V e r b o s e   ( " { 0 } :   R e t r i e v i n g   W M I   O S   i n f o r m a t i o n "   - f   $ C o m p u t e r )  
                                         $ O S   =   G e t - W m i O b j e c t   - C o m p u t e r N a m e   $ C o m p u t e r   W i n 3 2 _ O p e r a t i n g S y s t e m   - E r r o r A c t i o n   S t o p                                  
                                 }   C a t c h   {  
                                         $ O S   =   N e w - O b j e c t   P S O b j e c t   - P r o p e r t y   @ {  
                                                 C a p t i o n   =   $ _ . E x c e p t i o n . M e s s a g e  
                                                 V e r s i o n   =   $ _ . E x c e p t i o n . M e s s a g e  
                                         }  
                                 }  
                                 T r y   {  
                                         W r i t e - V e r b o s e   ( " { 0 } :   A t t e m p t i n g   r e m o t e   r e g i s t r y   a c c e s s "   - f   $ C o m p u t e r )  
                                         $ r e m o t e R e g   =   [ M i c r o s o f t . W i n 3 2 . R e g i s t r y K e y ] : : O p e n R e m o t e B a s e K e y ( [ M i c r o s o f t . W i n 3 2 . R e g i s t r y H i v e ] : : L o c a l M a c h i n e , $ C o m p u t e r )  
                                         I f   ( $ O S . O S A r c h i t e c t u r e   - e q   ' 6 4 - b i t ' )   {  
                                                 $ v a l u e   =   $ r e m o t e R e g . O p e n S u b K e y ( " S O F T W A R E \ M i c r o s o f t \ W i n d o w s   N T \ C u r r e n t V e r s i o n " ) . G e t V a l u e ( ' D i g i t a l P r o d u c t I d 4 ' ) [ 0 x 3 4 . . 0 x 4 2 ]  
                                         }   E l s e   {                                                  
                                                 $ v a l u e   =   $ r e m o t e R e g . O p e n S u b K e y ( " S O F T W A R E \ M i c r o s o f t \ W i n d o w s   N T \ C u r r e n t V e r s i o n " ) . G e t V a l u e ( ' D i g i t a l P r o d u c t I d ' ) [ 0 x 3 4 . . 0 x 4 2 ]  
                                         }  
                                         $ P r o d u c t K e y   =   " "      
                                         W r i t e - V e r b o s e   ( " { 0 } :   T r a n s l a t i n g   d a t a   i n t o   p r o d u c t   k e y "   - f   $ C o m p u t e r )  
                                         f o r   ( $ i   =   2 4 ;   $ i   - g e   0 ;   $ i - - )   {    
                                             $ r   =   0    
                                             f o r   ( $ j   =   1 4 ;   $ j   - g e   0 ;   $ j - - )   {    
                                                 $ r   =   ( $ r   *   2 5 6 )   - b x o r   $ v a l u e [ $ j ]    
                                                 $ v a l u e [ $ j ]   =   [ m a t h ] : : F l o o r ( [ d o u b l e ] ( $ r / 2 4 ) )    
                                                 $ r   =   $ r   %   2 4    
                                             }    
                                             $ P r o d u c t K e y   =   $ m a p [ $ r ]   +   $ P r o d u c t K e y    
                                             i f   ( ( $ i   %   5 )   - e q   0   - a n d   $ i   - n e   0 )   {    
                                                 $ P r o d u c t K e y   =   " - "   +   $ P r o d u c t K e y    
                                             }    
                                         }  
                                 }   C a t c h   {  
                                         $ P r o d u c t K e y   =   $ _ . E x c e p t i o n . M e s s a g e  
                                 }                  
                                 $ o b j e c t   =   N e w - O b j e c t   P S O b j e c t   - P r o p e r t y   @ {  
                                         C o m p u t e r n a m e   =   $ C o m p u t e r  
                                         P r o d u c t K e y   =   $ P r o d u c t K e y  
                                         O S D e s c r i p t i o n   =   $ o s . C a p t i o n  
                                         O S V e r s i o n   =   $ o s . V e r s i o n  
                                 }    
                                 $ o b j e c t . p s t y p e n a m e s . i n s e r t ( 0 , ' P r o d u c t K e y . I n f o ' )  
                                 $ o b j e c t  
                         }   E l s e   {  
                                 $ o b j e c t   =   N e w - O b j e c t   P S O b j e c t   - P r o p e r t y   @ {  
                                         C o m p u t e r n a m e   =   $ C o m p u t e r  
                                         P r o d u c t K e y   =   ' U n r e a c h a b l e '  
                                         O S D e s c r i p t i o n   =   ' U n r e a c h a b l e '  
                                         O S V e r s i o n   =   ' U n r e a c h a b l e '  
                                 }      
                                 $ o b j e c t . p s t y p e n a m e s . i n s e r t ( 0 , ' P r o d u c t K e y . I n f o ' )  
                                 $ o b j e c t                                                        
                         }  
                 }  
         }  
 } 
